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
    //@IBOutlet weak var lblTile:UILabel!
    @IBOutlet weak var lblInput: UITextField!
    
    let dropDown = DropDown()
    //var searchs = [Search]()
    let fruitsArray = [["pk":"mango"],["pk": "apple"],["pk": "banana"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown.anchorView = vmDropDown
        dropDown.dataSource = fruitsArray.map { (number: [String: String]) -> String in
            return number["pk"]!
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self]
            (index: Int, item: String) in
            print("Selected item:\(item) at index: \(index)")
            self.lblInput.text = fruitsArray[index]["pk"]
        }
    }
    //MARK:- showFruiteOptions
    @IBAction func showFruiteOptions(_ sender:Any) {
        dropDown.show()
    }
}

extension TableViewTestController {
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
            //self.searchs = candles
        }
    }
}
