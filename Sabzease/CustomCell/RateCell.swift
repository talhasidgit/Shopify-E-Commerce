//
//  RateCell.swift
//  Demo
//
//  Created by MAC on 06/03/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTaxPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblWeightBase: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
