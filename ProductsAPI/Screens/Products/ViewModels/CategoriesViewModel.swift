//
//  CategoriesViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

final class CategoriesViewModel {
  
  @Published var categories: [CategoryViewModel] = []
  
  @Published var errorMessage: String?
  
  @Published var categoriesLoading: Bool = false
  
  @Published var selectedCategories: [CategoryViewModel] = [] {
    didSet {
      filterActive = selectedCategories == appliedCategories
    }
  }
  
  var filterActive: Bool = false
  
  var appliedCategories: [CategoryViewModel] = []
  
  func downloadCategories() {
    
    // Only get new instances when there's no active filter so we don't
    // lose selection state.
    guard appliedCategories.isEmpty else { return }
    
    categoriesLoading = true
    APIService.getAndDecode(from: "https://dummyjson.com/products/categories",
                            decode: [String].self) { [weak self] result in
      
      guard let strongSelf = self else { return }
      
      switch result {
        case .success(let categories):
          var tempCategories: [CategoryViewModel] = []
        
          for category in categories {
            tempCategories.append(CategoryViewModel(title: category))
          }
        
          strongSelf.categories = tempCategories
        case .failure(_):
          strongSelf.errorMessage = "Could not get categories. Try again soon."
      }
      
      strongSelf.categoriesLoading = false
    }
  }
  
  func handleSelectedCategory(_ category: CategoryViewModel) {
    if selectedCategories.contains(category) {
      selectedCategories.removeAll(where: { $0 == category })
    } else {
      selectedCategories.append(category)
    }
  }
}
