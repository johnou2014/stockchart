//
//  TableViewTestController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/5/29.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

class TableViewTestController: UIViewController {
    @IBOutlet weak var vmDropDown: UIView!
    @IBOutlet weak var lblInput: UITextField!
    @IBOutlet weak var stockTableViewList: UITableView!
    
    let dropDown = DropDown()
    var watchs = [Watch]()
    var searchOptions = [Search]()
    var filterSearchOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStockList()
        self.loadDataFromAPI()
        dropDown.anchorView = vmDropDown
        dropDown.dataSource = filterSearchOptions.map { (number: String) -> String in
            return number
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDown.bounds.height)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self]
            (index: Int, item: String) in
            print("Selected item:\(item) at index: \(index)")
            self.lblInput.text = filterSearchOptions[index]
        }
    }
    private func presentAlertController(withTitle title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- showFruiteOptions
    @IBAction func showFruiteOptions(_ sender:Any) {
      var result = self.searchOptions.filter { (item) -> Bool in
        if let _ = self.watchs.first(where: { $0.stock == item.symbol }) {
            return false
        }
            return true
       }
        //print("result 1=",result)
        result.sort(by: {(s1, s2) -> Bool in
            if s1.symbol.contains(self.lblInput.text!.uppercased()) {
                return true
            } else {
            return false
            }
        })
       
        let resultOptions = result.map { (number: Search) -> String in
            return number.symbol
        }
        //print("result 2=",resultOptions)
        self.filterSearchOptions = resultOptions
        dropDown.dataSource = resultOptions
        dropDown.show()
    }
    @IBAction func onClickAddButton(_ sender: Any) {
        if var text = self.lblInput.text, !text.isEmpty {
            //MARK: - 检查是否在选择项目里面，不存在不让添加
            text = text.uppercased()
            var isInTheOption = false
            for(_, item) in self.watchs.enumerated() {
                if item.stock == text {
                    presentAlertController(withTitle: "Cannot be added repeatedly")
                    return
                }
            }
            for (_, item) in self.searchOptions.enumerated() {
                if item.symbol == text {
                    isInTheOption = true
                    break
                }
            }
            if !isInTheOption {
                presentAlertController(withTitle: "The stock name entered is incorrect")
                return
            }
            self.addUserStock(symbol: text)
        }
    }
    @IBAction func onClickDeleteButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: stockTableViewList)
        guard let indexpath = stockTableViewList.indexPathForRow(at: point) else {
            return
        }
        watchs.remove(at: indexpath.row)
        stockTableViewList.beginUpdates()
        stockTableViewList.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        stockTableViewList.endUpdates()
    }
}

extension TableViewTestController {
    @objc func getStockList() {
        AF.request("http://easytrade007.com:8080/api/v1/getStockList", method: .get, parameters: ["username":getUserInfo(type: "username")], headers: headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data as Any)
            var candles: [Search] = [Search]()
            for json in json.arrayValue {
                let info = Search(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, description: json["description"].stringValue)
                candles.append(info)
            }
            self.searchOptions = candles
        }
    }
}
extension TableViewTestController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        watchs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editTableViewTest", for: indexPath) as? EditTableViewTest else {
            return UITableViewCell()
        }
        cell.lblName.text = watchs[indexPath.row].stock
        cell.lblNameDetail.text = watchs[indexPath.row].stock_name
        if watchs[indexPath.row].pk > 40 {
            cell.lblImage.image = UIImage(from: .themify, code: "stats.up", textColor: .green, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
        } else {
            cell.lblImage.image = UIImage(from: .themify, code: "stats.down", textColor: .red, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("indexPath =",indexPath.row)
            let stock = watchs[indexPath.row].stock
            print("stock =",stock, watchs[indexPath.row])
            self.showAlertDialog(tableView, indexPath: indexPath, stock: stock)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "watchDetail",
           let indexPath = stockTableViewList?.indexPathForSelectedRow,
           let destinationViewController: CanvasViewController = segue.destination as? CanvasViewController {
            print("active =",watchs[indexPath.row])
            destinationViewController.watch = watchs[indexPath.row]
        }
    }
    func showAlertDialog(_ tableView: UITableView, indexPath: IndexPath, stock: String) {
            // Declare Alert
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Delete?", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 print("Ok button click...")
                self.delUserStock(stock: stock)
                self.watchs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .bottom)
            })
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button click...")
            }
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
}
extension TableViewTestController {
    func addUserStock(symbol: String) {
        let addStockInfo = AddStockInfo(username: getUserInfo(type: "username"), symbol: symbol)
        AF.request("http://easytrade007.com:8080/api/v1/addUserStock/", method: .post, parameters: addStockInfo,encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            //let json = JSON(response.data as Any)
            if (response.data == nil) {
                self.presentAlertController(withTitle: "add stock failed！")
                return
            } else {
                self.watchs.insert(Watch(pk: 0, user: "", stock: self.lblInput.text!, stock_name: self.lblInput.text!, user_id: 0, stock_id: 0), at: 0)
                self.stockTableViewList.beginUpdates()
                self.stockTableViewList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                self.stockTableViewList.endUpdates()
                self.lblInput.text = nil
            }
        }
    }
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getUserStock", method: .get, parameters: ["username":getUserInfo(type: "username")], headers: headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data as Any)
            var candles: [Watch] = [Watch]()
            for json in json.arrayValue {
                let info = Watch(pk: json["pk"].intValue, user: json["user"].stringValue, stock: json["stock"].stringValue, stock_name: json["stock_name"].stringValue, user_id: json["user_id"].intValue, stock_id: json["stock_id"].intValue)
                candles.append(info)
            }
            print("candles =", candles)
            self.watchs = candles
            self.stockTableViewList.reloadData()
            self.lblInput.text = nil
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
            //let json = JSON(response.data as Any)
            if (response.data != nil) {
                self.presentAlertController(withTitle: "删除失败！")
            } else {
                self.presentAlertController(withTitle: "删除成功！")
            }
            self.loadDataFromAPI()
        }
    }
}
