//
//  ProductsResponse.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

/*
 
 Many products:
 
 {
     "products": [....]
 }
 
 */

struct ProductsResponse: Decodable {
  let products: [Product]
  let total: Int
}
