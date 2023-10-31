//
//  LineItemCell.swift
//  Demo
//
//  Created by MAC on 29/05/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class LineItemCell: UITableViewCell {

    @IBOutlet weak var lblQTY: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.viewBack.layer.borderWidth = 1
//        self.viewBack.layer.borderColor = UIColor.black.cgColor
        DispatchQueue.main.async {
            self.viewBack.layer.cornerRadius = 10
            self.viewBack.clipsToBounds = true
            self.viewBack.dropShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
