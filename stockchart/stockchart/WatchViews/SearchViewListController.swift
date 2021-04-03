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
        //self.tableView.register(SearchTableCell.self, forCellReuseIdentifier: "searchTableCell")
        setupTableView()
        loadDataFromAPI()
        setUpSearchBar()
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "watchDetail",
           let indexPath = tableView?.indexPathForSelectedRow,
           let destinationViewController: WatchDetailViewController = segue.destination as? WatchDetailViewController {
            print("searchs === prepare", searchs)
            destinationViewController.watch = watches[indexPath.row]
        }*/
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
        print("searchBar.text ===",searchController.searchBar.text)
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
    func setupTableView() {
        self.tableView.register(SearchTableCell.self, forCellReuseIdentifier: identifier)
    }
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Search Stock List"
        tableView.reloadData()
    }
   
}
extension SearchViewListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("searchs ==",searchs)
        return searchs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableCell {
            cell.configurateTheCell(searchs[indexPath.row])
            print("cell ====",cell)
            return cell
        }
        return UITableViewCell()
    }
    
}
extension SearchViewListController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            searchs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
        
    }
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
