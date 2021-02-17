//
//  Watch.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/15.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Watch {
    let pk: Int
    let user: String
    let stock: String
    let stock_name: String
    let user_id: Int
    let stock_id: Int
}

extension Watch {
    static var itemsList = [[String:Any]]()
    static func getWatchList() -> [Watch] {
        Alamofire.request("http://easytrade007.com:8080/api/v1/getUserStock", method: .get, parameters: ["username":"john.ou"]).validate().responseJSON { response in
            var list = [Watch]()
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                /*for (index, item) in json {
                    list.append(item)
                }*/
                //Watch.itemsList = json as! [[String:Any]]
            case .failure(let error):
                print(error)
            }
        }
        return [Watch(pk:90,user:"john.ou",stock:"AAPL",stock_name:"Apple Inc.",user_id:5,stock_id:2), Watch(pk:94,user:"john.ou",stock:"BA",stock_name:"The Boeing Company",user_id:5,stock_id:1), Watch(pk:30,user:"john.ou",stock:"FB",stock_name:"Facebook Inc",user_id:5,stock_id:4), Watch(pk:91,user:"john.ou",stock:"FSLR",stock_name:"First Solar Inc.",user_id:5,stock_id:22), Watch(pk:89,user:"john.ou",stock:"FSLY",stock_name:"Fastly Inc",user_id:5,stock_id:11), Watch(pk:72,user:"john.ou",stock:"GLD",stock_name:"Spdr Gold Trust Gold Shares Npv",user_id:5,stock_id:8), Watch(pk:78,user:"john.ou",stock:"JMIA",stock_name:"Jumia Technologies",user_id:5,stock_id:10), Watch(pk:85,user:"john.ou",stock:"JPM",stock_name:"JP Morgan Chase & Co.",user_id:5,stock_id:20), Watch(pk:40,user:"john.ou",stock:"LYFT",stock_name:"Lyft Inc",user_id:5,stock_id:5), Watch(pk:41,user:"john.ou",stock:"MSFT",stock_name:"Microsoft Corp",user_id:5,stock_id:6),Watch(pk:92,user:"john.ou",stock:"NET",stock_name:"Cloudflare Inc",user_id:5,stock_id:23),Watch(pk:73,user:"john.ou",stock:"NFLX",stock_name:"Netflix Inc",user_id:5,stock_id:14),Watch(pk:43,user:"john.ou",stock:"NIO",stock_name:"Nio Inc",user_id:5,stock_id:9),Watch(pk:93,user:"john.ou",stock:"NVTA",stock_name:"Invitae Corporation",user_id:5,stock_id:19),Watch(pk:39,user:"john.ou",stock:"PLTR",stock_name:"Palantir Technologies Inc.",user_id:5,stock_id:3),Watch(pk:61,user:"john.ou",stock:"QQQ",stock_name:"Nasdaq ETF",user_id:5,stock_id:15),Watch(pk:42,user:"john.ou",stock:"SNOW",stock_name:"Snowflake Inc",user_id:5,stock_id:7),Watch(pk:59,user:"john.ou",stock:"SPY",stock_name:"S&P500",user_id:5,stock_id:16),Watch(pk:76,user:"john.ou",stock:"SRNE",stock_name:"Sorrento Therapeutics Inc",user_id:5,stock_id:12),Watch(pk:77,user:"john.ou",stock:"TQQQ",stock_name:"3x QQQ",user_id:5,stock_id:17),Watch(pk:75,user:"john.ou",stock:"TSLA",stock_name:"Tesla Inc",user_id:5,stock_id:13),Watch(pk:86,user:"john.ou",stock:"UBER",stock_name:"Uber Technologies Inc",user_id:5,stock_id:21)
]
    }
}
