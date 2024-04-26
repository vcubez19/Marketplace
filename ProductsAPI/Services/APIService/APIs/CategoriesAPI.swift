//
//  CategoriesAPI.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 4/26/24.
//

import Foundation

enum CategoriesAPI: API {
  case getCategories
  
  var scheme: HTTPScheme {
    switch self {
      case .getCategories:
        return .https
    }
  }
  
  var baseURL: String {
    switch self {
      case .getCategories:
        return "dummyjson.com"
    }
  }
  
  var path: String {
    switch self {
      case .getCategories:
        return "/products/categories"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      case .getCategories:
        return nil
    }
  }
  
  var method: HTTPMethod {
    switch self {
      case .getCategories:
        return .get
    }
  }
}
