//
//  SeachTableCell.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/3/28.
//

import Foundation
import UIKit

class SearchTableCell: UITableViewCell {
    
    @IBOutlet private var pkLabel:UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var symbolLabel: UILabel!
    @IBOutlet private var descriptionsLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        pkLabel.text = nil
//        nameLabel.text = nil
//        symbolLabel.text = nil
//        descriptionsLabel.text = nil
     
    }
    func viewDidLoad() {
        pkLabel.text = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        descriptionsLabel.text = nil
    }

    // MARK: Cell Configuration

    func configurateTheCell(_ search: Search) {
        print("name =", pkLabel)
//        pkLabel.text = String(search.pk)
//        nameLabel.text = search.name
//        symbolLabel.text = search.symbol
//        descriptionsLabel.text = search.description
        //print("searchCell =",pkLabel.text, nameLabel.text)
    }
}
