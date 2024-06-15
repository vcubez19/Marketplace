//
//  Product.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

struct Product: Codable, Equatable {
  let id: Int
  let title, description, category: String
  let price, discountPercentage, rating: Double
  let stock: Int
  let tags: [String]
  let brand: String?
  let sku: String
  let weight: Int
  let dimensions: Dimensions
  let warrantyInformation, shippingInformation, availabilityStatus: String
  let reviews: [Review]
  let returnPolicy: String
  let minimumOrderQuantity: Int
  let meta: Meta
  let images: [String]
  let thumbnail: String
    
  var originalPrice: Double {
    let discount = self.price * (self.discountPercentage / 100)
    let discountedPrice = self.price + discount
    return discountedPrice
  }
  
  /// Some objects from the server do not contain the thumbnail in their images field.
  /// Since some do, they will be removed and the thumbnail will be placed at the beginning.
  var imagesWithThumbnailFirst: [String] {
    return [self.thumbnail] + self.images.filter { !$0.contains("thumbnail") }
  }
  
  var brandText: String {
    return self.brand ?? "Unbranded"
  }
    
  static func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id
  }
  
  struct Dimensions: Codable {
    let width, height, depth: Double
  }

  struct Meta: Codable {
    let createdAt, updatedAt, barcode: String
    let qrCode: String
  }

  struct Review: Codable {
    let rating: Int
    let comment, date, reviewerName, reviewerEmail: String
  }
}
