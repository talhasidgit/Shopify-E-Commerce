//
//  ProductNameCell.swift
//  ezfresh.pk
//
//  Created by MAC on 11/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit

class ProductNameCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        DispatchQueue.main.async {
//            self.viewBG.layer.cornerRadius = 20
//            self.viewBG.clipsToBounds = true
//            self.viewBG.dropShadow()
        }
    }
}
