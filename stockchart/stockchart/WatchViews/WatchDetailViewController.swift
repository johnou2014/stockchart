//
//  WatchDetailViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/15.
//
import Foundation
import UIKit
import SwiftIconFont

let collectionViewA = KSBinanceController();

class WatchDetailViewController: UIViewController {

    @IBOutlet private var pkLabel: UILabel!
    @IBOutlet private var userLabel:UILabel!
    @IBOutlet private var stockLabel: UILabel!
    @IBOutlet private var stockNameLabel: UILabel!
    @IBOutlet private var userIdLabel: UILabel!
    @IBOutlet private var stockIdLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    var watch: Watch?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let watch = watch {
            navigationItem.title = watch.stock_name
            pkLabel.text = "pk:" + String(watch.pk)
            userLabel.text = "user:" + watch.user
            stockLabel.text = "stock:" + watch.stock
            stockNameLabel.text = "name:" + watch.stock_name
            userIdLabel.text = "userId:" + String(watch.user_id)
            stockIdLabel.text = "stockId:" + String(watch.stock_id)
            if watch.pk > 40 {
            thumbnailImageView.image = UIImage(from: .themify, code: "stats.up", textColor: .green, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
            } else {
                thumbnailImageView.image = UIImage(from: .themify, code: "stats.down", textColor: .red, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
            }
            let ctr = KSBinanceController.init()
            self.view.addSubview(ctr.view)
        }
        
    }
}

