/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ProductImage : Codable {
	let id : Int?
	let product_id : Int?
	let position : Int?
	let created_at : String?
	let updated_at : String?
	let alt : String?
	let width : Int?
	let height : Int?
	let src : String?
	let variant_ids : [Int]?
	let admin_graphql_api_id : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case product_id = "product_id"
		case position = "position"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case alt = "alt"
		case width = "width"
		case height = "height"
		case src = "src"
		case variant_ids = "variant_ids"
		case admin_graphql_api_id = "admin_graphql_api_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
		position = try values.decodeIfPresent(Int.self, forKey: .position)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		alt = try values.decodeIfPresent(String.self, forKey: .alt)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		src = try values.decodeIfPresent(String.self, forKey: .src)
		variant_ids = try values.decodeIfPresent([Int].self, forKey: .variant_ids)
		admin_graphql_api_id = try values.decodeIfPresent(String.self, forKey: .admin_graphql_api_id)
	}
}
