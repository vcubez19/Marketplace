//
//  ProductsViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation
import os

/// A view model for the all products
final class ProductsViewModel {
  
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                     category: String(describing: ProductsViewModel.self))
 
  @Published var products: [ProductPreviewViewModel] = []
  
  @Published var productsFiltered: [ProductPreviewViewModel] = []
  
  @Published var errorMessage: String?
  
  @Published var downloadingProducts: Bool = false
  
  private var productsSkip: Int = 0
  private var productsLimit: Int = 30
  private var moreProducts: Bool = true
  
  func downloadProducts() async {
    guard moreProducts else { return }
    
    downloadingProducts = true
    
    do {
      let productsResponse = try await APIService.getAndDecode(ProductsResponse.self, from: "https://dummyjson.com/products?skip=\(productsSkip)&limit=\(productsLimit)")
      products.append(contentsOf: productsResponse.products.map({ ProductPreviewViewModel(product: $0) }))
      productsSkip += productsLimit
      moreProducts = products.count != productsResponse.total
    }
    catch {
      Self.logger.error("Failed to download products.")
      errorMessage = "Could not get products."
    }
    
    downloadingProducts = false
  }
  
  func applyCategoryFilter(_ categoryNames: [String]) {
    /// Set the filtered data source to contain products that have category names contained in the provided array .
    productsFiltered = categoryNames.isEmpty ? products : products.filter({ categoryNames.contains($0.category) })
  }
}
