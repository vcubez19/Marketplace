//
//  SearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation

/// Supplies search history and live search results.
final class LiveSearchViewModel {
  
  private var searchHistorySearchModels: [Search] = [] {
    didSet {
      searchHistory = searchHistorySearchModels.compactMap({$0.searchText})
    }
  }
  
  @Published var searchHistory: [String] = []
  @Published var searchResults: [ProductPreviewSearchViewModel] = []
  
  @Published var loadingSearchHistory: Bool = false
  @Published var loadingSearchResults: Bool = false
  
  @Published var searchHistoryErrorMessage: String?
  @Published var searchResultsErrorMessage: String?
  
  var searchText: String = "" {
    didSet {
      guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
      downloadSearchResults()
    }
  }
  
  private var searchDebounceTimer: Timer?

  // Number of search results to show for the initial live search. Once the user
  // hits the "search" button, they will be directed to the next screen showing
  // all the search results paginated.
  private var liveSearchLimit: Int = 10
  
  func downloadSearchHistory() {
    guard let searches = CoreDataService.shared.getSearchHistory() else {
      searchHistoryErrorMessage = "Could not retrieve your search history."
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
    
    searchDebounceTimer?.invalidate()
    searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
      guard let strongSelf = self else { return }
      
      APIService.getAndDecode(from: "https://dummyjson.com/products/search?q=\(strongSelf.searchText)&limit=\(strongSelf.liveSearchLimit)",
                              decode: ProductsResponse.self) { result in
        switch result {
          case .success(let productsResponse):
            strongSelf.searchResults = productsResponse.products.map({ ProductPreviewSearchViewModel(product: $0) })
          case .failure(_):
            strongSelf.searchResultsErrorMessage = "Could not get search results."
        }
      }
    }
  }
}
