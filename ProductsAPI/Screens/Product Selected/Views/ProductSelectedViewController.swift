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
    
    let productSelectedView = ProductSelectedView(product: product)
    let hostingController = UIHostingController(rootView: productSelectedView)
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)

    NSLayoutConstraint.activate([
        hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    hostingController.didMove(toParent: self)
  }
}
