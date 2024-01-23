//
//  SearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation

final class SearchViewModel {
  
  @Published var searchHistory: [String] = []
  @Published var searchResults: [ProductPreviewViewModel] = []
  
  @Published var loadingSearchHistory: Bool = false
  @Published var loadingSearchResults: Bool = false
  
  var searchText: String = ""
  
  func downloadSearchHistory() {
    // TODO: Replace will core data call
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
      self.searchHistory = ["Buttholes", "Cute girls"]
    }
  }
  
  func downloadSearchResults() {
    
  }
}
