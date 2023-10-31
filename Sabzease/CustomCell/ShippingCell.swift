//
//  ShippingCell.swift
//  ezfresh.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit

class ShippingCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        DispatchQueue.main.async {
            self.viewBG.dropShadow()
        }
    }
}
