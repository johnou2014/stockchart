//
//  KSLineChartCell.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/27.
//

import UIKit

let KSLineChartCellIdentifier = "KSLineChartCellIdentifier"

class KSLineChartCell: KSBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func initialize(tableView:UITableView) -> KSLineChartCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: KSLineChartCellIdentifier)
        if cell == nil {
            cell = KSLineChartCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: KSLineChartCellIdentifier)
        }
        return cell as! KSLineChartCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    /// 创建子控件
    override func createChildViews() {
        
    }
}
