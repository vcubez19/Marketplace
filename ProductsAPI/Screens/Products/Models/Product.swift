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
