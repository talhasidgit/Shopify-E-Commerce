//
//  SummaryCell.swift
//  Demo
//
//  Created by MAC on 22/05/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {
    
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    @IBOutlet weak var lblProdPrice: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnCompleteOrder: UIButton!
    
    @IBOutlet weak var btnContinueShopping: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            
            self.btnCompleteOrder.layer.cornerRadius = 10
            self.btnCompleteOrder.clipsToBounds = true
            
            self.btnContinueShopping.layer.cornerRadius = 10
            self.btnContinueShopping.layer.borderWidth = 2
            self.btnContinueShopping.layer.borderColor = AppTheme.sharedInstance.Orange.cgColor
            self.btnContinueShopping.backgroundColor = UIColor.white
            self.btnContinueShopping.clipsToBounds = true
            
            self.bgView.layer.cornerRadius = 20
            self.bgView.clipsToBounds = true
            self.bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            self.bgView.dropShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
