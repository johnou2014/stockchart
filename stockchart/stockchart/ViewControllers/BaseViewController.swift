//
//  BaseViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let textAttributes: [NSAttributedString.Key: AnyObject] = [:]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
       
        

        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        /*navigationController?.navigationBar.titleTextAttributes = [.foregroundClor: UIColor.hexColor(0x33333)]
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)*/
    }
}

