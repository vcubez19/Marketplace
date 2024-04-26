//
//  ProductsAPIEndpointsTests.swift
//  ProductsAPITests
//
//  Created by Vincent Cubit on 4/26/24.
//

import XCTest
@testable import ProductsAPI

final class ProductsAPIEndpointsTests: XCTestCase {
  
  func test_get_products_request_is_valid() {
    let getProductsAPI = ProductsAPI.getProducts(skip: 0, limit: 20)
    
    XCTAssertEqual(getProductsAPI.scheme, .https, "The scheme should be https")
    XCTAssertEqual(getProductsAPI.baseURL, "dummyjson.com", "The baseURL should be dummyjson.com")
    XCTAssertEqual(getProductsAPI.path, "/products", "The path should be /products")
    XCTAssertEqual(getProductsAPI.parameters, [URLQueryItem(name: "skip", value: "\(0)"),
                                              URLQueryItem(name: "limit", value: "\(20)")], "The parameters should be skip=0&limit=20")
    XCTAssertEqual(getProductsAPI.method, .get, "The method should be get")
    
    XCTAssertEqual(APIService.buildURL(endpoint: getProductsAPI).url?.absoluteString, "https://dummyjson.com/products?skip=0&limit=20", "The full url is incorrect.")
  }
  
}
