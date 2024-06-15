//
//  TestProductsService.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/26/24.
//

import Foundation

struct TestProductsService {
    static let shared = TestProductsService()

    let products: [Product] = [
      Product(id: 1,
              title: "Product 1",
              description: "Product 1 description",
              category: "category",
              price: 14.99,
              discountPercentage: 4.88,
              rating: 4.55,
              stock: 4,
              tags: [],
              brand: "Brand",
              sku: "SKU",
              weight: 55,
              dimensions: Product.Dimensions(width: 5.7, height: 9.9, depth: 7.88),
              warrantyInformation: "Warranty information",
              shippingInformation: "Shipping Information",
              availabilityStatus: "Available",
              reviews: [],
              returnPolicy: "Return policy",
              minimumOrderQuantity: 80,
              meta: Product.Meta(createdAt: "Created", updatedAt: "Updated", barcode: "bar code", qrCode: "qr code"),
              images: [],
              thumbnail: "")
    ]

    private init() {}
}
