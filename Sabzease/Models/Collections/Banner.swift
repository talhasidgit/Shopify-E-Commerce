//
//  Banners.swift
//  ezfresh.pk
//
//  Created by Mazhar on 24/06/2021.
//  Copyright © 2021 ExdNow. All rights reserved.
//

import Foundation
struct Banner : Codable {
    let images : [Image]?
    
    enum CodingKeys: String, CodingKey {

        case images = "images"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy:
                                            CodingKeys.self)
        images = try values.decodeIfPresent([Image].self, forKey: .images)
    }

}
