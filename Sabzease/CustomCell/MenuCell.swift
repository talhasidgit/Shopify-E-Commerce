//
//  MenuCell.swift
//  Demo
//
//  Created by MAC on 21/01/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
