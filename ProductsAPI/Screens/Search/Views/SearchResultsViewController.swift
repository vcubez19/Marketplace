//
//  SearchResultsViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import UIKit

/// Displays results from a user's search
final class SearchResultsViewController: UIViewController {

  // MARK: Stored properties
  
  var viewModel: SearchViewModel!
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  // MARK: Methods
  
  private func setupView() {
    view.backgroundColor = .green
  }
}
