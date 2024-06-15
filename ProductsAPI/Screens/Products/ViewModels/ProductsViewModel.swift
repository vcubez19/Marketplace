//
//  ProductsViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation
import os

final class ProductsViewModel {
  
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                     category: String(describing: ProductsViewModel.self))
 
  @Published var originalProducts: [ProductPreviewViewModel] = [] {
    didSet {
      products = originalProducts
    }
  }
  
  @Published var products: [ProductPreviewViewModel] = []
  
  @Published var errorMessage: String?
  
  @Published var downloadingProducts: Bool = false
  
  private var productsSkip: Int = 0
  private var productsLimit: Int = 30
  private var moreProducts: Bool = true
  
  func downloadProducts() async {
    guard moreProducts else { return }
    
    downloadingProducts = true
    
    do {
      let productsResponse = try await APIService.request(ProductsResponse.self, from: ProductsAPI.getProducts(skip: productsSkip, limit: productsLimit))
      
      originalProducts.append(contentsOf: productsResponse.products.map({ ProductPreviewViewModel(product: $0) }))
      productsSkip += productsLimit
      moreProducts = originalProducts.count != productsResponse.total
    }
    catch {
      Self.logger.error("Failed to download products. \(String(describing: error))")
      errorMessage = "Could not get products."
    }
    
    downloadingProducts = false
  }
  
  func applyCategoryFilter(_ categoryNames: [String]) {
    products = categoryNames.isEmpty ? originalProducts : originalProducts.filter({ categoryNames.contains($0.category) })
  }
}
