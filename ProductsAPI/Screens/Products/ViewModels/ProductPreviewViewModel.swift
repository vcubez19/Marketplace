//
//  ProductPreviewViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

/// A view model for a product on the products screen.
struct ProductPreviewViewModel {
  private let product: Product
  
  init(product: Product) {
    self.product = product
  }
  
  var productThumbnailData: Data?
  
  var productPriceText: String {
    return "$" + String(product.price)
  }
  
  var productTitleText: String {
    return product.title
  }
  
  private mutating func downloadThumbnail() async {
    productThumbnailData = await ImageService.downloadImageDataAsync(from: product.thumbnail)
  }
}
