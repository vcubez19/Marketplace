//
//  CategoriesViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation
import os

final class CategoriesViewModel {
  
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                     category: String(describing: CategoriesViewModel.self))
  
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
  
  func downloadCategories() async {
    
    // Only get new instances when there's no active filter so we don't
    // lose selection state.
    guard appliedCategories.isEmpty else { return }
    
    categoriesLoading = true
    
    do {
      let categoriesFromServer = try await APIService.getAndDecode([String].self, from: "https://dummyjson.com/products/categories")
      
      var tempCategories: [CategoryViewModel] = []
    
      for category in categoriesFromServer {
        tempCategories.append(CategoryViewModel(title: category))
      }
    
      categories = tempCategories
    } catch {
      Self.logger.error("Failed to download categories.")
      errorMessage = "Could not get categories."
    }
    
    categoriesLoading = false
  }
  
  func handleSelectedCategory(_ category: CategoryViewModel) {
    if selectedCategories.contains(category) {
      selectedCategories.removeAll(where: { $0 == category })
    } else {
      selectedCategories.append(category)
    }
  }
}
