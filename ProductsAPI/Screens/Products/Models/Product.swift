//
//  Product.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

struct Product: Decodable {
  let id: Int
  let title, description: String
  let price: Int
  let discountPercentage, rating: Double
  let stock: Int
  let brand, category, thumbnail: String
  let images: [String]
  
  var originalPrice: Int {
    let discount = Double(self.price) * (self.discountPercentage / 100)
    let discountedPrice = Double(self.price) + discount
    return Int(discountedPrice.rounded())
  }
  
  /// Some objects from the server do not contain the thumbnail in their images field.
  /// Since some do, they will be removed and the thumbnail will be placed at the beginning.
  var imagesWithThumbnailFirst: [String] {
    return [self.thumbnail] + self.images.filter { !$0.contains("thumbnail") }
  }
}

/*
 
 1 product:
 
{
     "id": 1,
     "title": "iPhone 9",
     "description": "An apple mobile which is nothing like apple",
     "price": 549,
     "discountPercentage": 12.96,
     "rating": 4.69,
     "stock": 94,
     "brand": "Apple",
     "category": "smartphones",
     "thumbnail": "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg",
     "images": [
         "https://cdn.dummyjson.com/product-images/1/1.jpg",
         "https://cdn.dummyjson.com/product-images/1/2.jpg",
         "https://cdn.dummyjson.com/product-images/1/3.jpg",
         "https://cdn.dummyjson.com/product-images/1/4.jpg",
         "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg"
     ]
}
 
 */
