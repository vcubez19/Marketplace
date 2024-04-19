//
//  ProductsAPI.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 4/19/24.
//

import Foundation

enum ProductsAPI: API {
  
  case products(skip: Int, limit: Int)
  
  var scheme: HTTPScheme {
    switch self {
      case .products:
        return .https
    }
  }
  
  var baseURL: String {
    switch self {
      case .products:
        return "https://dummyjson.com"
    }
  }
  
  var path: String {
    switch self {
      case .products:
        return "/products"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      case .products(let skip, let limit):
        return [URLQueryItem(name: "skip", value: "\(skip)"),
                URLQueryItem(name: "limit", value: "\(limit)")]
    }
  }
  
  var method: HTTPMethod {
    switch self {
      case .products:
        return .get
    }
  }
}
