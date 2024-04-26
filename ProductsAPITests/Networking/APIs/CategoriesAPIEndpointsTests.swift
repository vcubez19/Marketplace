//
//  CategoriesAPIEndpointTests.swift
//  ProductsAPITests
//
//  Created by Vincent Cubit on 4/26/24.
//

import XCTest
@testable import ProductsAPI

final class CategoriesAPIEndpointsTests: XCTestCase {

  func test_get_categories_request_is_valid() {
    let getCategoriesAPI = CategoriesAPI.getCategories
    
    XCTAssertEqual(getCategoriesAPI.scheme, .https, "The scheme should be https")
    XCTAssertEqual(getCategoriesAPI.baseURL, "dummyjson.com", "The baseURL should be dummyjson.com")
    XCTAssertEqual(getCategoriesAPI.path, "/products/categories", "The path should be /categories")
    XCTAssertNil(getCategoriesAPI.parameters, "The parameters should be nil")
    XCTAssertEqual(getCategoriesAPI.method, .get, "The method should be get")
    
    XCTAssertEqual(APIService.buildURL(endpoint: getCategoriesAPI).url?.absoluteString, "https://dummyjson.com/products/categories", "The full url is incorrect.")
  }

}
