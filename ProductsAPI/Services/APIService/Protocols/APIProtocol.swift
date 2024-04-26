//
//  APIProtocol.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 4/19/24.
//

import Foundation

protocol API {
  /// .http or .https
  var scheme: HTTPScheme { get }
  
  // Example: "dummyjson.com"
  var baseURL: String { get }
  
  // "/products"
  var path: String { get }
  
  // [URLQueryItem(name: "limit", value: 20)]
  var parameters: [URLQueryItem]? { get }
  
  // "GET"
  var method: HTTPMethod { get }
}
