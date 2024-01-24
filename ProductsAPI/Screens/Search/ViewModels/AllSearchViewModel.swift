//
//  AllSearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/24/24.
//

import Foundation

/// Supplies all search results paginated
final class AllSearchViewModel {
  
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
  
  func downloadAllSearchResults() {
    
    guard moreProducts else { return }
    
    APIService.getAndDecode(from: "https://dummyjson.com/products/search?q=\(search)&skip=\(productsSkip)&limit=\(productsLimit)",
                            decode: ProductsResponse.self) { [weak self] result in
      guard let strongSelf = self else { return }
      
      switch result {
        case .success(let productsResponse):
          strongSelf.allSearchResults.append(contentsOf: productsResponse.products.map({ ProductPreviewSearchViewModel(product: $0) }))
        
          strongSelf.productsSkip += strongSelf.productsLimit
        
          strongSelf.moreProducts = strongSelf.allSearchResults.count != productsResponse.total
        case .failure(_):
          Log.error("Failed to get search results for search: \(strongSelf.search).")
          strongSelf.errorMessage = "Could not get search results."
      }
    }
  }
}
