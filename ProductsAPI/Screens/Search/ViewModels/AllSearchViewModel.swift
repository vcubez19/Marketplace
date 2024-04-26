//
//  AllSearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/24/24.
//

import Foundation
import os

/// Supplies all search results paginated
final class AllSearchViewModel {
  
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                     category: String(describing: AllSearchViewModel.self))
  
  private let search: String
  
  var currentSearch: String {
    return search
  }
  
  init(search: String) {
    self.search = search
  }
  
  @Published var allSearchResults: [ProductPreviewSearchViewModel] = []
  
  private var productsSkip: Int = 0
  private var productsLimit: Int = 30
  
  @Published var errorMessage: String?
  
  private var moreProducts: Bool = true
  
  func downloadAllSearchResults() async {
    
    guard moreProducts else { return }
    
    do {
      let productsResponse =  try await APIService.getAndDecode(ProductsResponse.self, from: SearchAPI.search(search: search, skip: productsSkip, limit: productsLimit))
                                                                
      allSearchResults.append(contentsOf: productsResponse.products.map({ ProductPreviewSearchViewModel(product: $0) }))
      productsSkip += productsLimit
      moreProducts = allSearchResults.count != productsResponse.total
    } catch {
      Self.logger.error("Failed to get search results for search: \(self.search).")
      errorMessage = "Could not get search results."
    }
  }
}
