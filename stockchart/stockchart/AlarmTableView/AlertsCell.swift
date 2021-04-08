//
//  AlertCell.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/4/8.
//

import Foundation
import UIKit
//时间戳转成字符串
func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
    let date:Date = Date.init(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter.init()
    if dateFormat == nil {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }else{
        formatter.dateFormat = dateFormat
    }
    return formatter.string(from: date as Date)
}

class AlertsCell: UITableViewCell {

    
    @IBOutlet private var alertSymbol: UILabel!
    @IBOutlet private var alertName: UILabel!
    @IBOutlet private var alertCreateTime:UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        alertName.text = nil
        alertCreateTime.text = nil
        alertSymbol.text = nil
    }

    // MARK: Cell Configuration

    func configurateTheCell(_ alert: Alert) {
        alertName.text = alert.name
        alertCreateTime.text = timeIntervalChangeToTimeStr(timeInterval: alert.create_time )
        alertSymbol.text = alert.symbol
    }
}
