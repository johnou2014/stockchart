//
//  AlertCell.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/4/8.
//

import Foundation
import UIKit
//时间戳转成字符串
func timeStampToString(timeStamp:String)->String {

    var string = NSString(string: timeStamp)
    
    var timeSta:TimeInterval = string.doubleValue
    var dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日"

    var date = NSDate(timeIntervalSince1970: timeSta)
    
    print(dfmatter.string(from: date as Date))
    return dfmatter.string(from: date as Date)
}
func timeIntervalChangeToTimeStr(timeStamp: Double) ->String {
    let k = NSDate.init(timeIntervalSince1970: timeStamp / 1000)
    let formatter = DateFormatter.init()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    let y = formatter.string(from: k as Date)
    return y
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
        alertCreateTime.text = timeIntervalChangeToTimeStr(timeStamp: alert.create_time )
        alertSymbol.text = alert.symbol
    }
}
