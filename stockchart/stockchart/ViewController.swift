//
//  ViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let homeVC = HomeViewController()
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        homeVC.tabBarItem.title = "首页"
        let navigationHomeVC = UINavigationController(rootViewController: homeVC)
        self.addChild(navigationHomeVC)
        
        let protfolioVC = ProtfolioViewController()
        protfolioVC.tabBarItem.image = UIImage(systemName: "camera.metering.spot")
        protfolioVC.tabBarItem.selectedImage = UIImage(systemName: "camera.metering.spot.fill")?.withRenderingMode(.alwaysOriginal)
        protfolioVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        protfolioVC.tabBarItem.title = "图集"
        let navigationProtfolioVC = UINavigationController(rootViewController: protfolioVC)
        self.addChild(navigationProtfolioVC)
        
        let alertsVC = AlertsViewController()
        alertsVC.tabBarItem.image = UIImage(systemName: "drop.triangle")
        alertsVC.tabBarItem.selectedImage = UIImage(systemName: "drop.triangle.fill")?.withRenderingMode(.alwaysOriginal)
        alertsVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        alertsVC.tabBarItem.title = "报警"
        let navigationAlertsVC = UINavigationController(rootViewController: alertsVC)
        self.addChild(navigationAlertsVC)
        
        let newsVC = NewsViewController()
        newsVC.tabBarItem.image = UIImage(systemName: "message")
        newsVC.tabBarItem.selectedImage = UIImage(systemName: "message.fill")?.withRenderingMode(.alwaysOriginal)
        newsVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        newsVC.tabBarItem.title = "信息"
        let navigationNewsVC = UINavigationController(rootViewController: newsVC)
        self.addChild(navigationNewsVC)
        
        let mineVC = MineViewController()
        mineVC.tabBarItem.image = UIImage(systemName: "person")
        mineVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        mineVC.tabBarItem.title = "我的"
        let navigationMineVC = UINavigationController(rootViewController: mineVC)
        self.addChild(navigationMineVC)
        
    }
    
}

