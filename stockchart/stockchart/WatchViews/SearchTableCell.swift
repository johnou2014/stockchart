//
//  SeachTableCell.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/3/28.
//

import Foundation
import UIKit

class SearchTableCell: UITableViewCell {
    @IBOutlet private var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var pk:UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var descriptions:  UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pk.text = nil
        name.text = nil
        symbol.text = nil
        descriptions.text = nil
     
    }

    // MARK: Cell Configuration

    func configurateTheCell(_ search: Search) {
        pk.text = String(search.pk)
        name.text = search.name
        symbol.text = search.symbol
        descriptions.text = search.description
        print("searchCell =",pk.text, name.text)
        if search.pk > 40 {
        thumbnailImageView.image = UIImage(from: .themify, code: "stats.up", textColor: .green, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
        } else {
            thumbnailImageView.image = UIImage(from: .themify, code: "stats.down", textColor: .red, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
        }
    }
}
