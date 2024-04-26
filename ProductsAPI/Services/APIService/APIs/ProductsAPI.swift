//
//  ProductsAPI.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 4/19/24.
//

import Foundation

enum ProductsAPI: API {
  
  case getProducts(skip: Int, limit: Int)
  
  var scheme: HTTPScheme {
    switch self {
      case .getProducts:
        return .https
    }
  }
  
  var baseURL: String {
    switch self {
      case .getProducts:
        return "https://dummyjson.com"
    }
  }
  
  var path: String {
    switch self {
      case .getProducts:
        return "/products"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      case .getProducts(let skip, let limit):
        return [URLQueryItem(name: "skip", value: "\(skip)"),
                URLQueryItem(name: "limit", value: "\(limit)")]
    }
  }
  
  var method: HTTPMethod {
    switch self {
      case .getProducts:
        return .get
    }
  }
}
