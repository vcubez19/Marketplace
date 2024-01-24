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
      Log.error("Failed to create a URL while making a network request. Bad URL: \(urlString).")
      return
    }
    
    let urlRequest = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      if let error = error {
        Log.error("Error present when making a network request: \(error)")
      }
      
      guard let data = data else {
        Log.error("No data when making a network request expecting some data.")
        completion(.failure(.noData))
        return
      }
      
      do {
        let decodedType = try JSONDecoder().decode(decode.self, from: data)
        completion(.success(decodedType))
      }
      catch {
        Log.error("Decoding error when decoding data from a network request.")
        completion(.failure(.decodingError))
      }
    }
      .resume()
  }
}
