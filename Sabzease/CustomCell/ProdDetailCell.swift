//
//  ProdDetailCell.swift
//  ezfresh.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit

class ProdDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var viewBG: UIView!
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
