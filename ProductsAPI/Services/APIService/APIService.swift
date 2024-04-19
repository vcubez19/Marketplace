//
//  APIService.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

struct APIService {

  /// Downloads and decodes data into the provided type from a server.
  static func getAndDecode<T: Decodable>(_ decode: T.Type, from urlString: String) async throws -> T {
    guard let url = URL(string: urlString) else {
      throw APIError.invalidURL
    }
    
    let urlRequest = URLRequest(url: url)
    
    do  {
      let (data, _) = try await URLSession.shared.data(for: urlRequest)
      return try JSONDecoder().decode(decode.self, from: data)
    }
    catch {
      throw error
    }
  }
}
