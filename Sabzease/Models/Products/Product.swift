//
//  Product.swift
//  ezfresh.pk
//
//  Created by Mazhar on 02/08/2021.
//  Copyright © 2021 ExdNow. All rights reserved.
//

import Foundation
struct Product : Codable {

    var available : Bool!
    var body : String!
    var compareAtPriceMax : String!
    var compareAtPriceMin : String!
    var featuredImage : FeaturedImage!
    var handle : String!
    var id : Int!
    var image : String!
    var images : [Images]?
    var price : String!
    var priceMax : String!
    var priceMin : String!
    var tags : [String]!
    var title : String!
    var type : String!
    var url : String!
    var variants : [Variants]!
    var vendor : String!


}
struct FeaturedImage : Codable {

    var alt : String!
    var aspectRatio : Float!
    var height : Int!
    var url : String!
    var width : Int!


}
