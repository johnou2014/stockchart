import UIKit
import Alamofire
import SwiftyJSON
let identifier: String = "searchTableCell"

class SearchViewController: UIViewController {
     
    // 搜索控制器
    var searchController: UISearchController!
     
    //展示列表
    var tableView: UITableView!
     
    //原始数据集
     var searchs = [Search]()
    //搜索过滤后的结果集
    var searchArray:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // 初始化搜索控制器
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        // 将搜索控制器集成到导航栏上
        navigationItem.searchController = self.searchController
         
        //创建表视图
        let tableViewFrame = CGRect(x: 0, y: 20, width: self.view.frame.width,
                                    height: self.view.frame.height-20)
        self.tableView = UITableView(frame: tableViewFrame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "MyCell")
        self.view.addSubview(self.tableView!)
        getStockList()
    }
}
 
extension SearchViewController: UISearchResultsUpdating {
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else { return }
        if searchedText == "" {
            getStockList()
        } else {
            self.searchs = searchs.filter({
                $0.name.contains(searchedText)
            })
            tableView.reloadData()
        }
    }
}
 
extension SearchViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchArray.count
        } else {
            return self.searchs.count
        }
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    /*{
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "MyCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                     for: indexPath)
            if self.searchController.isActive {
                cell.textLabel?.text = self.searchArray[indexPath.row]
                return cell
            } else {
                cell.textLabel?.text = self.searchs[indexPath.row].name
                return cell
            }
    }*/
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableCell {
            cell.configurateTheCell(searchs[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
extension SearchViewController{
    @objc func getStockList() {
        AF.request("http://easytrade007.com:8080/api/v1/getStockList", method: .get, parameters: nil).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data)
            print("json ==",json)
            var candles: [Search] = [Search]()
            for json in json.arrayValue {
                let info = Search(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, description: json["description"].stringValue)
                candles.append(info)
            }
            self.searchs = candles
        }
            
    }
}
