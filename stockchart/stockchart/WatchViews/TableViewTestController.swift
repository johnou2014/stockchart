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
    var stringArr = [Search]()
    var searchOptions = [Search]()
    var fruitsArray = ["mango","apple","banana"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getStockList()
        self.loadDataFromAPI()
        dropDown.anchorView = vmDropDown
        dropDown.dataSource = fruitsArray.map { (number: String) -> String in
            return number
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self]
            (index: Int, item: String) in
            print("Selected item:\(item) at index: \(index)")
            self.lblInput.text = fruitsArray[index]
            
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
        if let _ = self.stringArr.first(where: { $0.symbol == item.symbol }) {
            return false
        }
            return true
       }
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
        self.fruitsArray = resultOptions
        dropDown.dataSource = resultOptions
        dropDown.show()
    }
    @IBAction func onClickAddButton(_ sender: Any) {
        if var text = self.lblInput.text, !text.isEmpty {
            //MARK: - 检查是否在选择项目里面，不存在不让添加
            text = text.uppercased()
            var isInTheOption = false
            print(text)
            for(_, item) in self.stringArr.enumerated() {
                if item.symbol == text {
                    presentAlertController(withTitle: "Cannot be added repeatedly")
                    return
                }
            }
            
            for (index, item) in self.searchOptions.enumerated() {
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
            /*
            self.stringArr.insert(self.lblInput.text!, at: 0)
            stockTableViewList.beginUpdates()
            stockTableViewList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
            stockTableViewList.endUpdates()
            self.lblInput.text = nil
            */
        }
    }
    @IBAction func onClickDeleteButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: stockTableViewList)
        guard let indexpath = stockTableViewList.indexPathForRow(at: point) else {
            return
        }
        stringArr.remove(at: indexpath.row)
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
            let json = JSON(response.data)
            print("json ==",json)
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
        stringArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewTest", for: indexPath) as? EditTableViewTest else {
            return UITableViewCell()
        }
        cell.lblName.text = stringArr[indexPath.row].symbol
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
extension TableViewTestController {
    func addUserStock(symbol: String) {
        let addStockInfo = AddStockInfo(username: getUserInfo(type: "username"), symbol: symbol)
        print("addStockInfo =",addStockInfo)
        AF.request("http://easytrade007.com:8080/api/v1/addUserStock/", method: .post, parameters: addStockInfo,encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let json = JSON(response.data) as Any
            print("addStockInfo reponse =",json)
            if (response.data == nil) {
                self.presentAlertController(withTitle: "add stock failed！")
                return
            } else {
                self.stringArr.insert(Search(pk: 0, name: self.lblInput.text!, symbol: self.lblInput.text!, description: ""), at: 0)
                self.stockTableViewList.beginUpdates()
                self.stockTableViewList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                self.stockTableViewList.endUpdates()
                self.lblInput.text = nil
            }
        }
    }
    // MARK: -链式请求
    @objc func loadDataFromAPI() {
        AF.request("http://easytrade007.com:8080/api/v1/getStockList", method: .get, parameters: ["username":getUserInfo(type: "username")], headers: headers).validate().responseJSON { response in
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
            print("candles =", candles)
            self.stringArr = candles
            self.stockTableViewList.reloadData()
            /*
            self.stockTableViewList.beginUpdates()
            self.stockTableViewList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
            self.stockTableViewList.endUpdates()
            */
            self.lblInput.text = nil
        }
        //MARK: -本地静态数据
    }
}
