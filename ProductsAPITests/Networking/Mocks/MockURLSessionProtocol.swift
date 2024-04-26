//
//  MockURLSessionProtocol.swift
//  ProductsAPITests
//
//  Created by Vincent Cubit on 4/26/24.
//

import Foundation
import XCTest

final class MockURLSessionProtocol: URLProtocol {
  
  static var loadingHandler: (() -> (Data?, HTTPURLResponse))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    guard let handler = MockURLSessionProtocol.loadingHandler else {
      XCTFail("The loading handler is not set.")
      return
    }
    
    let (data, response) = handler()
    
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    
    if let data = data {
      client?.urlProtocol(self, didLoad: data)
    }
    
    client?.urlProtocolDidFinishLoading(self)
  }
  
  override func stopLoading() {
    
  }
}
