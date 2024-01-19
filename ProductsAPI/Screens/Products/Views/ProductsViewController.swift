//
//  ProductsViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import UIKit
import Combine

/// Displays all products
final class ProductsViewController: UICollectionViewController {
  
  // MARK: UI Elements
  
  private let loadingIndicator: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .medium)
    view.color = .label
    view.hidesWhenStopped = true
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  // MARK: Stored properties
  
  private let viewModel: ProductsViewModel = ProductsViewModel()
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setBindings()
    downloadProducts()
  }
  
  // MARK: Methods
  
  private func setupView() {
    view.addSubview(loadingIndicator)
    
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func setBindings() {
    viewModel.$products
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] products in
        // TODO: Apply snapshot
      })
      .store(in: &cancellables)
    
    viewModel.$errorMessage
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] message in
        guard let message = message else { return }
        self?.showAlertFromBottom(message: message, messageContext: .error)
      })
      .store(in: &cancellables)
    
    viewModel.$downloadingProducts
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] downloading in
        if downloading {
          self?.loadingIndicator.startAnimating()
        } else {
          self?.loadingIndicator.stopAnimating()
        }
      })
      .store(in: &cancellables)
  }
  
  private func downloadProducts() {
    viewModel.downloadProducts()
  }
}
