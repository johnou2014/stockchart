//
//  Watch.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/15.
//

import Foundation
import Alamofire
import SwiftyJSON
struct Watch: Decodable {
    let pk: Int
    let user: String
    let stock: String
    let stock_name: String
    let user_id: Int
    let stock_id: Int
}
