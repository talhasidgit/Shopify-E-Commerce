//
//  OrderCell.swift
//  ezfresh.pk
//
//  Created by MAC on 14/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
        
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblOrderTime: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        DispatchQueue.main.async {
            self.viewBG.layer.cornerRadius = 10
            self.viewBG.clipsToBounds = true
            self.viewBG.dropShadow()
        }
    }
}
