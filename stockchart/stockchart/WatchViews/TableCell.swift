//
//  TableCell.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/15.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {

    //@IBOutlet private var pkLabel: UILabel!
    //@IBOutlet private var userLabel:UILabel!
    @IBOutlet private var stockLabel: UILabel!
    @IBOutlet private var stockNameLabel: UILabel!
    //@IBOutlet private var userIdLabel: UILabel!
    //@IBOutlet private var stockIdLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //pkLabel.text = nil
        //userLabel.text = nil
        stockLabel.text = nil
        stockNameLabel.text = nil
        //userIdLabel.text = nil
        //stockIdLabel.text = nil
        thumbnailImageView.image = nil
    }

    // MARK: Cell Configuration

    func configurateTheCell(_ watch: Watch) {
        //pkLabel.text = String(watch.pk)
        //userLabel.text = watch.user
        stockLabel.text = watch.stock
        stockNameLabel.text = watch.stock_name
        //userIdLabel.text = String(watch.user_id)
        //stockIdLabel.text = String(watch.stock_id)
        if watch.pk > 40 {
        thumbnailImageView.image = UIImage(from: .themify, code: "stats.up", textColor: .green, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
        } else {
            thumbnailImageView.image = UIImage(from: .themify, code: "stats.down", textColor: .red, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
        }
    }
}
