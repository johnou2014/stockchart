//
//  WatchViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//
import UIKit
import Alamofire
import SwiftyJSON
import Foundation
struct DelUserInfo: Encodable {
    let username: String
    let symbol: String
}
class WatchViewController: UITableViewController,UISearchControllerDelegate,UISearchBarDelegate {
    var watchs = [Watch]()
    let searchController = UISearchController(searchResultsController:nil)
    let identifier: String = "tableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromAPI()
        setUpSearchBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "watchDetail",
           let indexPath = tableView?.indexPathForSelectedRow,
           let destinationViewController: CanvasViewController = segue.destination as? CanvasViewController {
            destinationViewController.watch = watchs[indexPath.row]
        }
    }
}
extension WatchViewController:UISearchResultsUpdating {
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Add Stock"
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.searchController = searchController
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        if searchedText == "" {
            loadDataFromAPI()
        } else {
            self.watchs = watchs.filter({
                $0.stock_name.contains(searchedText)
            })
            tableView.reloadData()
        }
    }
}
extension WatchViewController {
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
        vc.watchs = watchs
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension WatchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? TableCell {
            cell.configurateTheCell(watchs[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableView Delegate

extension WatchViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("indexPath =",indexPath.row)
            let stock = watchs[indexPath.row].stock
            delUserStock(stock: stock)
            watchs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    //MARK: -删除用户股票
    @objc func delUserStock(stock: String) {
        let delUserInfo = DelUserInfo(username: getUserInfo(type:"username"), symbol: stock)
        AF.request( "http://easytrade007.com:8080/api/v1/delUserStock/",method: .post, parameters:delUserInfo, encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            if (response.data != nil) {
                self.presentAlertController(withTitle: "删除失败！")
            } else {
                self.presentAlertController(withTitle: "删除成功！")
            }
            self.loadDataFromAPI()
        }
    }
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getUserStock", method: .get, parameters: ["username":getUserInfo(type: "username")],headers:headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            var candles: [Watch] = [Watch]()
            for json in json.arrayValue {
                let info = Watch(pk: json["pk"].intValue, user: json["user"].stringValue, stock: json["stock"].stringValue, stock_name: json["stock_name"].stringValue, user_id: json["user_id"].intValue, stock_id: json["stock_id"].intValue)
                candles.append(info)
            }
            self.watchs = candles
            self.setupUI()
            print("刷新成功！")
        }
        //MARK: -本地静态数据
    }
}



