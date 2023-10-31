//
//  ProductCell.swift
//  Demo
//
//  Created by MAC on 18/01/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var lblSoldOut: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var viewCross: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
    //        self.viewBack.layer.borderWidth = 1
    //        self.viewBack.layer.borderColor = UIColor.black.cgColor
        }
    
}
