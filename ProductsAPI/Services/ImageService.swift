//
//  ImageService.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

/// Downloads images
struct ImageService {
  static func downloadImageDataAsync(from urlString: String) async -> Data? {
    guard let url = URL(string: urlString) else {
      // TODO: Log
      return nil
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      return data
    } catch {
      // TODO: Log
      return nil
    }
  }
}
