//
//  ezJson.swift
//  chart
//
//  Created by Sheldon_Gao on 2020/12/23.
//  Copyright © 2020 saeipi. All rights reserved.
//


import UIKit

class ezJson: NSObject {
    func getRequest(myUrl: String, completion : @escaping (AnyObject?, NSError?)->Void ){
        
        //setting up request
        var request = URLRequest(url: URL(string: myUrl)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 6
        let session = URLSession.shared
        
        //making request
        session.dataTask(with: request) {data, response, err in
            
            if (data != nil){
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        completion(jsonResult, nil)
                    }
                } catch let error as NSError {
                    completion(nil, error)
                }
            }
            else{
                completion(nil, err as NSError?);
            }
            }.resume()
    }
    
    func postRequest(myUrl: String, params: NSDictionary!, completion : @escaping (AnyObject?, NSError?)->Void ){
        
        //setting up request
        var request = URLRequest(url: URL(string: myUrl)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        //converting param dictionary into param string
        var postString : String! = ""
        for key in params.allKeys as! [String] {
            postString = postString + key + "=" + (params[key] as! String) + "&"
        }
        postString.remove(at: postString.index(before: postString.endIndex))
        
        //adding param string to httpBody
        request.httpBody = postString.data(using: .utf8)

        //making the request
        session.dataTask(with: request){
            data, response, err in
            if (data != nil){
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        completion(jsonResult, nil)
                    }
                } catch let error as NSError {
                    completion(nil, error)
                }
            }
            else{
                completion(nil, err as NSError?);
            }
            }.resume()
    }
}
