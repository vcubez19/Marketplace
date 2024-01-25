//
//  ProductSelectedViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/24/24.
//

import UIKit
import SwiftUI

final class ProductSelectedViewController: UIViewController {
  
  private let product: Product
  
  init(product: Product) {
    self.product = product
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    view.backgroundColor = .green
  }
}
