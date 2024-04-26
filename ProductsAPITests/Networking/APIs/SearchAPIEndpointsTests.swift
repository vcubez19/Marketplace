//
//  SearchAPIEndpointsTests.swift
//  ProductsAPITests
//
//  Created by Vincent Cubit on 4/26/24.
//

import XCTest
@testable import ProductsAPI

final class SearchAPIEndpointsTests: XCTestCase {

  func test_search_request_is_valid() {
    let searchAPI = SearchAPI.search(search: "laptop", skip: 0, limit: 20)
    
    XCTAssertEqual(searchAPI.scheme, .https, "The scheme should be https")
    XCTAssertEqual(searchAPI.baseURL, "dummyjson.com", "The baseURL should be dummyjson.com")
    XCTAssertEqual(searchAPI.path, "/products/search", "The path should be /products/search")
    XCTAssertEqual(searchAPI.parameters, [URLQueryItem(name: "q", value: "laptop"),
                                               URLQueryItem(name: "skip", value: "\(0)"),
                                               URLQueryItem(name: "limit", value: "\(20)")], "The parameters should be q=laptop&skip=0&limit=20")
    XCTAssertEqual(searchAPI.method, .get, "The method should be get")
    
    XCTAssertEqual(APIService.buildURL(endpoint: searchAPI).url?.absoluteString, "https://dummyjson.com/products/search?q=laptop&skip=0&limit=20", "The full url is incorrect.")
  }

}
