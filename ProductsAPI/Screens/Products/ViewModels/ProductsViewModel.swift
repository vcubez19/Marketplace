//
//  ProductsViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

/// A view model for the all products
final class ProductsViewModel {
 
  @Published var products: [ProductPreviewViewModel] = []
  
  @Published var errorMessage: String?
  
  @Published var downloadingProducts: Bool = false
  
  private var productsSkip: Int = 0
  private var productsLimit: Int = 30
  
  /// Will be set to false once the total number of products has been loaded.
  private var moreProducts: Bool = true
  
  func downloadProducts() {
    errorMessage = "testing error message"
//    guard moreProducts else { return }
//    
//    downloadingProducts = true
//    APIService.getAndDecode(from: "https://dummyjson.com/products?skip=\(productsSkip)&limit=\(productsLimit)",
//                            decode: ProductsResponse.self) { [weak self] result in
//      guard let strongSelf = self else { return }
//      
//      switch result {
//        case .success(let productsResponse):
//          strongSelf.products.append(contentsOf: productsResponse.products.map({ ProductPreviewViewModel(product: $0) }))
//        
//          strongSelf.productsSkip += strongSelf.productsLimit
//        
//          strongSelf.moreProducts = strongSelf.products.count != productsResponse.total
//        case .failure(_):
//          strongSelf.errorMessage = "Could not get products. Try again soon."
//      }
//      
//      strongSelf.downloadingProducts = false
//    }
  }
}
