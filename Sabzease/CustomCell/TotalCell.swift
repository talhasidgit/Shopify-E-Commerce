//
//  TotalCell.swift
//  ezfresh.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell {
    
    @IBOutlet weak var btnReOrder: UIButton!
    @IBOutlet weak var lblPKRShipping: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnReOrder.layer.cornerRadius = 10
        self.btnReOrder.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
