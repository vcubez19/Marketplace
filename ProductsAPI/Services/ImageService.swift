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
    
    let urlRequest = URLRequest(url: url)
    
    // Check cache
    if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
      return cachedResponse.data
    }
    
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      // Save image to cache
      let cachedResponseToSave = CachedURLResponse(response: response, data: data)
      URLCache.shared.storeCachedResponse(cachedResponseToSave, for: urlRequest)
      
      return data
    } catch {
      // TODO: Log
      return nil
    }
  }
}
