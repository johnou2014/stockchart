//
//  AlertsViewController2.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/12.
//
import UIKit

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
class AlertsViewController2: UITableViewController,UISearchControllerDelegate,UISearchBarDelegate {
    var alerts = [Alert]()
    let searchController = UISearchController(searchResultsController:nil)
    let identifier: String = "alertDetail"
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromAPI()
        setUpSearchBar()
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
extension AlertsViewController2:UISearchResultsUpdating {
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Add Stock2"
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
extension AlertsViewController2 {
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Watch List"
        tableView.reloadData()
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
extension AlertsViewController2 {
    
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

extension AlertsViewController2 {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("indexPath =",indexPath.row)
            alerts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/alarm/FB", method: .get, parameters: ["page":"1","size":"10"]).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            var candles: [Alert] = [Alert]()
            for json in json.arrayValue {
                let info = Alert(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, create_time: json["create_time"].doubleValue)
                candles.append(info)
            }
            self.alerts = candles
            self.setupUI()
            print("刷新成功！")
        }
    }
}
