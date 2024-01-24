//
//  LiveSearchResultsViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import UIKit
import Combine

/// Displays limited live results from a user's search
final class LiveSearchResultsViewController: UITableViewController {

  // MARK: UI Elements
  
  private let noSearchResultsButton: UIButton = {
    
    var configuration = UIButton.Configuration.plain()
    
    configuration.title = "No search results"
    configuration.image = UIImage(systemName: "exclamationmark.magnifyingglass")
    configuration.imagePadding = 4.0
    configuration.baseBackgroundColor = .label
    configuration.baseForegroundColor = .label

    let button = UIButton(type: .system)
    button.configuration = configuration
    button.isUserInteractionEnabled = false
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  // MARK: Stored properties
  
  var viewModel: LiveSearchViewModel!
  
  private var cancellables = Set<AnyCancellable>()
  
  private var dataSource: UITableViewDiffableDataSource<Int, ProductPreviewSearchViewModel>!
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setDataSource()
    setBindings()
  }
  
  // MARK: Methods
  
  private func setupView() {
    tableView.register(ProductPreviewSearchTableViewCell.self, forCellReuseIdentifier: ProductPreviewSearchTableViewCell.id)
    
    view.addSubview(noSearchResultsButton)
    NSLayoutConstraint.activate([
      noSearchResultsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
      noSearchResultsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  private func setDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                               cellProvider: { tableView, indexPath, product in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: ProductPreviewSearchTableViewCell.id, for: indexPath) as! ProductPreviewSearchTableViewCell
      
      cell.configure(with: product)
      
      return cell
    })
  }
  
  private func setBindings() {
    viewModel.$searchResults
      .receive(on: DispatchQueue.main)
      .sink { [weak self] products in
        self?.noSearchResultsButton.isHidden = !products.isEmpty
        self?.applySnapshot(with: products)
      }
      .store(in: &cancellables)
    
    viewModel.$searchResultsErrorMessage
      .receive(on: DispatchQueue.main)
      .sink { [weak self] message in
        guard let message = message else { return }
        self?.showAlertFromBottom(message: message, messageContext: .error)
      }
      .store(in: &cancellables)
  }
  
  private func applySnapshot(with products: [ProductPreviewSearchViewModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, ProductPreviewSearchViewModel>()
    
    snapshot.appendSections([0])
    snapshot.appendItems(products)
    
    dataSource.apply(snapshot)
  }
}

// MARK: UITableViewDelegate

extension LiveSearchResultsViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height / 5.0
  }
}
