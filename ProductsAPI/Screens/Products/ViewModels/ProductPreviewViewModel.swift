//
//  ProductPreviewViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

/// A view model for a product on the products screen.
struct ProductPreviewViewModel: Hashable {
  private let product: Product
  
  init(product: Product) {
    self.product = product
  }
    
  var productInformationText: String {
    return "$" + String(product.price) + " • " + product.title
  }
  
  func downloadThumbnail() async -> Data? {
    return await ImageService.downloadImageDataAsync(from: product.thumbnail)
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(product.id)
    hasher.combine(product.title)
  }

  static func == (lhs: ProductPreviewViewModel, rhs: ProductPreviewViewModel) -> Bool {
    return lhs.product.id == rhs.product.id && lhs.product.title == rhs.product.title
  }
}
