//
//  SearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation
import os

/// Supplies search history and live search results.
final class LiveSearchViewModel {
    
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                     category: String(describing: LiveSearchViewModel.self))
                                     
  @Published var searchHistory: [Search] = []
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
  
  /// Will be true unless the user searches from a search history search.
  /// Then we just return without assuming they want to search again.
  var shouldAutomaticallyOpenKeyboardOnAppear: Bool = true
  
  func downloadSearchHistory() {    
    guard let searches = CoreDataService.shared.getSearchHistory() else {
      searchHistoryErrorMessage = "Could not retrieve your search history."
      return
    }
    
    searchHistory = searches
  }
  
  func saveNewSearch() {
    CoreDataService.shared.saveNewSearch(searchText)
  }
  
  func deleteSearchAtIndex(_ index: Int) {
    let searchToDelete = searchHistory[index]
    guard CoreDataService.shared.deleteSearch(searchToDelete) else { return }
    
    searchHistory.remove(at: index)
  }
  
  func downloadSearchResults() {
    
    searchDebounceTimer?.invalidate()
    searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in

      guard let strongSelf = self else { return }
      
      Task {
        do {
          let productsResponse = try await APIService.getAndDecode(ProductsResponse.self, from: "https://dummyjson.com/products/search?q=\(strongSelf.searchText)&limit=\(strongSelf.liveSearchLimit)")
          strongSelf.searchResults = productsResponse.products.map({ ProductPreviewSearchViewModel(product: $0) })
        }
        catch {
          Self.logger.error("Failed to get search results for search: \(strongSelf.searchText).")
          strongSelf.searchResultsErrorMessage = "Could not get search results."
        }
      }
    }
  }
}
