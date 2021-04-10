//
//  ESRefreshTableViewController.swift
//  ESPullToRefreshExample
//
//  Created by lihao on 16/8/18.
//  Copyright © 2016年 egg swift. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public class ESRefreshTableViewController: UITableViewController {

    var alerts = [Alert]()
    public var page = 1
    public var total = 0
    public var type: ESRefreshExampleType = .defaulttype
    let identifier: String = "alertDetail"
    public override init(style: UITableView.Style) {
        print("style =",style)
        super.init(style: style)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        
//        self.tableView.register(UINib.init(nibName: "ESRefreshTableViewCell", bundle: nil), forCellReuseIdentifier: "ESRefreshTableViewCell")
//        self.tableView.register(UINib.init(nibName: "ESPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "ESPhotoTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 560
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        switch type {
        case .meituan:
            header = MTRefreshHeaderAnimator.init(frame: CGRect.zero)
            footer = MTRefreshFooterAnimator.init(frame: CGRect.zero)
        case .wechat:
            header = WCRefreshHeaderAnimator.init(frame: CGRect.zero)
            footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        default:
            header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
            footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
            break
        }
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.total = 0
            self?.page = 1
            self?.refresh()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        print("===", String.init(describing: type))
        self.tableView.refreshIdentifier = String.init(describing: type)
        self.tableView.expiredTimeInterval = 20.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.es.autoPullToRefresh()
        }
        refresh()
    }

    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.alerts.removeAll()
            AF.request("http://easytrade007.com:8080/api/v1/alarm/FB", method: .get, parameters: ["page": self.page,"size":"15"]).validate().responseJSON { response in
                if let err = response.error {
                    print("error \(err.localizedDescription)")
                    return
                }
               
                let res = JSON(response.data)
                let json = res["data"]
                self.total = res["count"].intValue
                var candles: [Alert] = [Alert]()
                for json in json.arrayValue {
                    let info = Alert(pk: json["pk"].intValue, name: json["name"].stringValue, symbol: json["symbol"].stringValue, create_time: json["create_time"].doubleValue)
                    candles.append(info)
                }
                self.alerts = candles
            self.tableView.reloadData()
                print(self.alerts)
            self.tableView.es.stopPullToRefresh()
        }
    }
}
    @objc func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page += 1
            if self.page * 15 < self.total {
                self.refresh()
                self.tableView.reloadData()
                self.tableView.es.stopLoadingMore()
            } else {
                self.tableView.es.noticeNoMoreData()
            }
        }
    }
    
    // MARK: - Table view data source
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? AlertsCell {
            cell.configurateTheCell(alerts[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
//    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        self.navigationController?.pushViewController(WebViewController.init(), animated: true)
//    }
    
}
