//
//  APIService.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

struct APIService {
  /// Downloads API data
  /// - Parameters:
  ///   - urlString: The API url as a string
  ///   - decode: The type to decode
  ///   - completion: A Result object containing the decoded type or an error
  static func getAndDecode<T: Decodable>(from urlString: String,
                                         decode: T.Type,
                                         completion: @escaping (Result<T, APIError>) -> Void) {
    guard let url = URL(string: urlString) else {
      // TODO: Log
      return
    }
    
    let urlRequest = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      if let error = error {
        // TODO: Log
      }
      
      guard let data = data else {
        // TODO: Log
        completion(.failure(.noData))
        return
      }
      
      do {
        let decodedType = try JSONDecoder().decode(decode.self, from: data)
        completion(.success(decodedType))
      }
      catch {
        // TODO: Log
        completion(.failure(.decodingError))
      }
    }
      .resume()
  }
}
