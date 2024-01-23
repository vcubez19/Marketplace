//
//  SearchResultsViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import UIKit
import Combine

/// Displays results from a user's search
final class SearchResultsViewController: UITableViewController {

  // MARK: Stored properties
  
  var viewModel: SearchViewModel!
  
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
        self?.applySnapshot(with: products)
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

extension SearchResultsViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height / 5.0
  }
}
