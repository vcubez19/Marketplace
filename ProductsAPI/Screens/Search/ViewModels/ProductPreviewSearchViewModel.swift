//
//  ProductPreviewSearchViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation

struct ProductPreviewSearchViewModel: Hashable {
  let product: Product
  
  init(product: Product) {
    self.product = product
  }
  
  var title: String {
    return product.title
  }
  
  var brandText: String {
    return product.brandText
  }
  
  var currentPriceText: String {
    return "$\(product.price)"
  }
  
  var originalPriceText: String {
    let formattedPrice = String(format: "%.2f", product.originalPrice)
    return "$\(formattedPrice)"
  }
  
  var discountPercentageText: String {
    return "\(Int(product.discountPercentage.rounded()))% off"
  }
  
  var stockText: String {
    return "\(product.stock) left"
  }
  
  func downloadThumbnail() async -> Data? {
    return await ImageService.downloadImageDataAsync(from: product.thumbnail)
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(product.id)
    hasher.combine(product.title)
  }

  static func == (lhs: ProductPreviewSearchViewModel, rhs: ProductPreviewSearchViewModel) -> Bool {
    return lhs.product.id == rhs.product.id && lhs.product.title == rhs.product.title
  }
}
