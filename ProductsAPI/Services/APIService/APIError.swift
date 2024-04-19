//
//  APIError.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

enum APIError: Error {
  case invalidURL
  case domainError
  case noData
  case decodingError
}
