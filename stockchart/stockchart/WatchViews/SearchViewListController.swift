//
//  SearchViewListController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/3/28.
//
struct AddStockInfo: Encodable {
    let username: String
    let symbol: String
}
import Foundation
import SwiftyJSON
import Alamofire
class SearchViewListController: UITableViewController,UISearchControllerDelegate,UISearchBarDelegate  {
    var searchs = [Search]() //默认的空Search 类型 查找出来的股票
    var watchs = [Watch]()  //默认的空Watch 类型 关注的股票
    let searchController = UISearchController(searchResultsController:nil)
    let identifier: String = "searchTableCell" //storyboard tableCell identifier
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromAPI() //获取列表
        setUpSearchBar()  //添加本地搜索
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
//MARK: -local search func
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
//MARK: -reload table list
extension SearchViewListController {
    func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.title = "Search Stock List"
        tableView.reloadData()
    }
    
}

extension SearchViewListController {
    //MARK: -tableList length
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchs.count
    }
    
    //MARK: -render Table List Item
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
    //MARK: -table item select func
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = searchs[indexPath.row].symbol
        for watch in watchs {
            if watch.stock == symbol {
                presentAlertController(withTitle: "已经存在你选择的\(searchs[indexPath.row].name)股票了")
                return
            }
            print("watch =", watch)
        }
        addUserStock(symbol: symbol)
    }
    private func presentAlertController(withTitle title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
   
    func addUserStock(symbol: String) {
        self.navigationController?.popToRootViewController(animated: true)
        let addStockInfo = AddStockInfo(username: "gaoxu", symbol: symbol)
        print("addStockInfo =",addStockInfo)
        AF.request("http://easytrade007.com:8080/api/v1/addUserStock/", method: .post, parameters: addStockInfo,encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            if (response.data != nil) {
                self.presentAlertController(withTitle: "添加失败！")
            } else {
                self.presentAlertController(withTitle: "添加成功！")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
extension SearchViewListController {
    
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getStockList", method: .get, parameters: ["username":"gaoxu"]).validate().responseJSON { response in
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
