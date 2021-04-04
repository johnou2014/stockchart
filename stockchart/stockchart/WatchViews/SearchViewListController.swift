//
//  SearchViewListController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/3/28.
//

import Foundation
import SwiftyJSON
import Alamofire
class SearchViewListController: UITableViewController,UISearchControllerDelegate,UISearchBarDelegate  {
    var searchs = [Search]()
    let searchController = UISearchController(searchResultsController:nil)
    let identifier: String = "searchTableCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromAPI()
        setUpSearchBar()
    }
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "watchDetail",
     let indexPath = tableView?.indexPathForSelectedRow,
     let destinationViewController: WatchDetailViewController = segue.destination as? WatchDetailViewController {
     print("searchs === prepare", searchs)
     destinationViewController.watch = watches[indexPath.row]
     }
     } */
}
extension SearchViewListController:UISearchResultsUpdating {
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Stock"
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.searchController = searchController
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        if searchedText == "" {
            loadDataFromAPI()
        } else {
            self.searchs = searchs.filter({
                $0.name.contains(searchedText)
            })
            tableView.reloadData()
        }
    }
}
extension SearchViewListController {
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Search Stock List"
        tableView.reloadData()
    }
    
}
extension SearchViewListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        //同一形式的单元格重复使用，在声明时已注册
        self.tableView!.register(SearchTableCell.self,forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! SearchTableCell
        if self.searchController.isActive {
            cell.textLabel?.text = self.searchs[indexPath.row].name
            return cell
        } else {
            cell.textLabel?.text = self.searchs[indexPath.row].name
            cell.textLabel?.tag = self.searchs[indexPath.row].pk
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("+++",indexPath[1])
        
    }
    
}
extension SearchViewListController {
    
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getStockList", method: .get, parameters: ["username":"john.ou"]).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            var candles: [Search] = [Search]()
            for json in json.arrayValue {
                let info = Search(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, description: json["description"].stringValue)
                candles.append(info)
            }
            self.searchs = candles
            self.setupUI()
            print("searchViewListController =刷新成功！")
        }
        //MARK: -本地静态数据
    }
}
