//
//  SearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation

final class SearchViewModel {
  
  private var searchHistorySearchModels: [Search] = [] {
    didSet {
      searchHistory = searchHistorySearchModels.compactMap({$0.searchText})
    }
  }
  
  @Published var searchHistory: [String] = []
  @Published var searchResults: [ProductPreviewViewModel] = []
  
  @Published var loadingSearchHistory: Bool = false
  @Published var loadingSearchResults: Bool = false
  
  @Published var errorMessage: String?
  
  var searchText: String = ""
  
  func downloadSearchHistory() {
    guard let searches = CoreDataService.shared.getSearchHistory() else {
      errorMessage = "Could not retrieve your search history."
      return
    }
    
    searchHistorySearchModels = searches
  }
  
  func saveNewSearch() {
    CoreDataService.shared.saveNewSearch(searchText)
  }
  
  func deleteSearchAtIndex(_ index: Int) {
    let searchToDelete = searchHistorySearchModels[index]
    guard CoreDataService.shared.deleteSearch(searchToDelete) else { return }
    
    searchHistory.remove(at: index)
  }
  
  func downloadSearchResults() {
    
  }
}
