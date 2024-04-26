//
//  SearchAPI.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 4/26/24.
//

import Foundation

enum SearchAPI: API {
  case search(search: String, skip: Int, limit: Int)
  
  var scheme: HTTPScheme {
    switch self {
      case .search:
        return .https
    }
  }
  
  var baseURL: String {
    switch self {
      case .search:
        return "dummyjson.com"
    }
  }
  
  var path: String {
    switch self {
      case .search:
        return "/products/search"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      case .search(let search, let skip, let limit):
        return [URLQueryItem(name: "search", value: "\(search)"),
                URLQueryItem(name: "skip", value: "\(skip)"),
                URLQueryItem(name: "limit", value: "\(limit)")]
    }
  }
  
  var method: HTTPMethod {
    switch self {
      case .search:
        return .get
    }
  }
}
