/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Products : Codable {
	let id : Int?
	let title : String?
	let body_html : String?
	let vendor : String?
	let product_type : String?
	let created_at : String?
	let handle : String?
	let updated_at : String?
	let published_at : String?
//	let template_suffix : String?
	let published_scope : String?
	let tags : String?
	let admin_graphql_api_id : String?
	let variants : [Variants]?
	let options : [Options]?
	let images : [Images]?
	let image : ProductImage?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case body_html = "body_html"
		case vendor = "vendor"
		case product_type = "product_type"
		case created_at = "created_at"
		case handle = "handle"
		case updated_at = "updated_at"
		case published_at = "published_at"
//		case template_suffix = "template_suffix"
		case published_scope = "published_scope"
		case tags = "tags"
		case admin_graphql_api_id = "admin_graphql_api_id"
		case variants = "variants"
		case options = "options"
		case images = "images"
		case image = "image"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		body_html = try values.decodeIfPresent(String.self, forKey: .body_html)
		vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
		product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		handle = try values.decodeIfPresent(String.self, forKey: .handle)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		published_at = try values.decodeIfPresent(String.self, forKey: .published_at)
//		template_suffix = try values.decodeIfPresent(String.self, forKey: .template_suffix)
		published_scope = try values.decodeIfPresent(String.self, forKey: .published_scope)
		tags = try values.decodeIfPresent(String.self, forKey: .tags)
		admin_graphql_api_id = try values.decodeIfPresent(String.self, forKey: .admin_graphql_api_id)
		variants = try values.decodeIfPresent([Variants].self, forKey: .variants)
		options = try values.decodeIfPresent([Options].self, forKey: .options)
		images = try values.decodeIfPresent([Images].self, forKey: .images)
		image = try values.decodeIfPresent(ProductImage.self, forKey: .image)
	}

}
