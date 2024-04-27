//
//  APIServiceTests.swift
//  ProductsAPITests
//
//  Created by Vincent Cubit on 4/26/24.
//

import Foundation
import XCTest
@testable import ProductsAPI

final class APIServiceTests: XCTestCase {
  
  private var session: URLSession!
  
  private var url: URL!
  
  override func setUp() {
    url = URL(string: "https://dummyjson.com/products?limit=20")
    
    let configuration = URLSessionConfiguration.ephemeral
    
    configuration.protocolClasses = [MockURLSessionProtocol.self]
    
    session = URLSession(configuration: configuration)
  }
  
  override func tearDown() {
    session = nil
    url = nil
  }
  
  func test_successful_products_response() async throws {
    guard let url = Bundle(for: type(of: self)).url(forResource: "MockProducts", withExtension: "json") else {
      XCTFail("Failed to find the static products file url.")
      return
    }
    
    guard let data = try? Data(contentsOf: url) else {
      XCTFail("Failed to get data from the static products file.")
      return
    }
    
    MockURLSessionProtocol.loadingHandler = {
      let response = HTTPURLResponse(url: self.url,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
      
      return (data, response!)
    }
    
    let result = try await APIService.request(session: session,
                                                   ProductsResponse.self,
                                                   from: ProductsAPI.getProducts(skip: 0, limit: 20))
    
    let staticJSON = try JSONDecoder().decode(ProductsResponse.self, from: data)
    
    XCTAssertEqual(result, staticJSON, "The returned response should be decoded correctly.")
  }
  
  func test_invalid_json_response_is_invalid() async throws {
    guard let url = Bundle(for: type(of: self)).url(forResource: "MockProducts", withExtension: "json") else {
      XCTFail("Failed to find the static products file url.")
      return
    }
    
    guard let data = try? Data(contentsOf: url) else {
      XCTFail("Failed to get data from the static products file.")
      return
    }
    
    MockURLSessionProtocol.loadingHandler = {
      let response = HTTPURLResponse(url: self.url,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
      
      return (data, response!)
    }
    
    do {
      _ = try await APIService.request(session: session,
                                                     [Product].self,
                                                     from: ProductsAPI.getProducts(skip: 0, limit: 20))
    } catch {
      XCTAssertTrue(error is DecodingError)
    }
  }
}
