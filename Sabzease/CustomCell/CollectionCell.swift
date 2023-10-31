//
//  CollectionCell.swift
//  Demo
//
//  Created by MAC on 16/04/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCollection: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
    //        self.viewBack.layer.borderWidth = 1
    //        self.viewBack.layer.borderColor = UIColor.black.cgColor
        self.imgCollection.layer.cornerRadius = 20
        self.imgCollection.layer.masksToBounds = true
        }
    
}
