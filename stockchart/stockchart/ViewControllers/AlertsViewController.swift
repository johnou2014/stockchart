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
class AlertsViewController: UITableViewController,UISearchControllerDelegate,UISearchBarDelegate {
    var alerts = [Alert]()
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
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) {
            [weak self] in
            self?.tableView.es.noticeNoMoreData()
        }
        setUpSearchBar()
        loadDataFromAPI()
    }
    
    // 当视图已经显示时调用该方法
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            print("视图已经显示")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "alertDetail" {
            
    }
//           let indexPath = tableView?.indexPathForSelectedRow,
//           let destinationViewController: CanvasViewController = segue.destination as? CanvasViewController {
//            destinationViewController.watch = alerts[indexPath.row]
//        }
    }
}
extension AlertsViewController:UISearchResultsUpdating {
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Alert List"
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.searchController = searchController
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        if searchedText == "" {
            loadDataFromAPI()
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
        self.tableView.es.noticeNoMoreData()
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
            cell.configurateTheCell(alerts[indexPath.row])
            return cell
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
        print("loadMore")
        self.tableView.reloadData()
        self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopLoadingMore()
            self.tableView.es.noticeNoMoreData()
    }
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("run asyncAfter 3.0")
            }
            self.tableView.reloadData()
            self.tableView.es.stopPullToRefresh()
        
        print("run stopPull")
    }
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        self.alerts.removeAll()
        AF.request("http://easytrade007.com:8080/api/v1/alarm/FB", method: .get, parameters: ["page":"1","size":"20"]).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)["data"]
            var candles: [Alert] = [Alert]()
            for json in json.arrayValue {
                let info = Alert(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, create_time: json["create_time"].doubleValue)
                candles.append(info)
            }
            self.alerts = candles
            print(self.alerts)
            self.setupUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopLoadingMore()
                self.tableView.es.noticeNoMoreData()
            }
            self.tableView.es.removeRefreshHeader()
            print("刷新成功！2")
        }
    }
}
