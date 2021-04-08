//
//  Alert.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/4/8.
//
import Foundation
struct Alert:Decodable {
   let pk: Int
   let name: String
  let  symbol: String
  let  create_time: Double
}
