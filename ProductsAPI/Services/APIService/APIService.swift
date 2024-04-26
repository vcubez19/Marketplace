//
//  APIService.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

struct APIService {

  static func buildURL(endpoint: API) -> URLComponents {
    var components = URLComponents()
    components.scheme = endpoint.scheme.rawValue
    components.host = endpoint.baseURL
    components.path = endpoint.path
    components.queryItems = endpoint.parameters
    
    return components
  }
  
  /// Downloads and decodes data into the provided type from a server.
  static func getAndDecode<T: Decodable>(_ decode: T.Type, from api: API) async throws -> T {
    
    guard let url = buildURL(endpoint: api).url else {
      throw APIError.invalidURL
    }
    
    print(url)
    
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
