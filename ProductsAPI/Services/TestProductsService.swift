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
//        Product(
//          id: 1,
//          title: "Product 1",
//          description: "Description for Product 1",
//          price: 10,
//          discountPercentage: 10.0,
//          rating: 5.0,
//          stock: 17,
//          brand: "Brand 1",
//          category: "Category 1",
//          thumbnail: "thumbnail_url_for_product_1",
//          images: ["image_url_for_product_1_1", "image_url_for_product_1_2", "image_url_for_product_1_3"]
//        ),
        Product(
          id: 2,
          title: "Product 2",
          description: "Description for Product 2",
          price: 20,
          discountPercentage: 10.0,
          rating: 4.5,
          stock: 20,
          brand: "Brand 2",
          category: "Category 2",
          thumbnail: "thumbnail_url_for_product_2",
          images: ["https://cdn.dummyjson.com/product-images/1/1.jpg",
                                   "https://cdn.dummyjson.com/product-images/1/2.jpg",
                                   "https://cdn.dummyjson.com/product-images/1/3.jpg"]
        ),
//        Product(
//          id: 3,
//          title: "Product 3",
//          description: "Description for Product 3",
//          price: 30,
//          discountPercentage: 10.0,
//          rating: 3.0,
//          stock: 90,
//          brand: "Brand 3",
//          category: "Category 3",
//          thumbnail: "thumbnail_url_for_product_3",
//          images: ["image_url_for_product_3_1", "image_url_for_product_3_2", "image_url_for_product_3_3"]
//        ),
//        Product(
//          id: 4,
//          title: "Product 4",
//          description: "Description for Product 4",
//          price: 40,
//          discountPercentage: 50.0,
//          rating: 4.7,
//          stock: 80,
//          brand: "Brand 4",
//          category: "Category 4",
//          thumbnail: "thumbnail_url_for_product_4",
//          images: ["image_url_for_product_4_1", "image_url_for_product_4_2", "image_url_for_product_4_3"]
//        )
    ]

    private init() {}
}
