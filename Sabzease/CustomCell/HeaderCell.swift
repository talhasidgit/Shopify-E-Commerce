//
//  HeaderCell.swift
//  ezfresh.pk
//
//  Created by MAC on 11/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var viewSep: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
}
