//
//  AlertsViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/12.
//
import UIKit
public enum ESRefreshExampleType: String {
    case defaulttype = "Default"
}
import Alamofire
import SwiftyJSON
import Foundation
import ESPullToRefresh
class AlertsViewController: UITableViewController,UISearchControllerDelegate {
    var alerts = [Alert]()
    var page = 1
    var total = 0
    let searchController = UISearchController(searchResultsController:nil)
    let identifier: String = "alertDetail"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.tableView.es.addPullToRefresh(animator: header) {
            [weak self] in
            self?.refresh()
            self?.page = 1
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) {
            [weak self] in
            self?.loadMore()
        }
        //setUpSearchBar()
    }
    
    // 当视图已经显示时调用该方法
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("视图已经显示")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "alertDetail",
           let indexPath = tableView?.indexPathForSelectedRow,
           let destinationViewController: CanvasViewController = segue.destination as? CanvasViewController {
            destinationViewController.alert = alerts[indexPath.row]
        }
    }
}
extension AlertsViewController:UISearchResultsUpdating {
    /*
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Alert List"
        searchController.hidesNavigationBarDuringPresentation = true
        //navigationItem.searchController = searchController
    }
 */
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        if searchedText == "" {
            refresh()
        } else {
            self.alerts = alerts.filter({
                $0.name.contains(searchedText)
            })
            tableView.reloadData()
        }
    }
}
extension AlertsViewController {
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Alert List"
        tableView.reloadData()
        self.tableView.es.stopPullToRefresh()
        self.tableView.es.stopLoadingMore()
    }
    private func presentAlertController(withTitle title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func pushController() {
        let vc = SearchViewListController()
        //vc.alerts = alerts
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension AlertsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? AlertsCell {
            if alerts.count >= indexPath.row {
            cell.configurateTheCell(alerts[indexPath.row])
            return cell
            } else {
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableView Delegate

extension AlertsViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("indexPath =",indexPath.row)
            alerts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    @objc func loadMore() {
        print("loadMore =", self.page, self.total)
        if(self.page * 20 < self.total) {
            self.page += 1
            self.refresh()
        } else {
        self.tableView.reloadData()
        self.tableView.es.stopPullToRefresh()
        self.tableView.es.stopLoadingMore()
        self.tableView.es.noticeNoMoreData()
        }
    }
    // MARK: -链式请求
    func refresh() {
        self.alerts = [Alert]()
        print("Ajax :page =",page,"total =", total)
        AF.request("http://easytrade007.com:8080/api/v1/alarm/FB", method: .get, parameters: ["page":page,"size":"20"], headers: headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let res = JSON(response.data as Any)
            let json = res["data"]
            self.total = res["count"].intValue
            var candles: [Alert] = [Alert]()
            for json in json.arrayValue {
                let info = Alert(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, create_time: json["create_time"].doubleValue)
                candles.append(info)
            }
            self.alerts = candles
            self.setupUI()
        }
    }
}
