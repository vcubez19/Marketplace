//
//  AllSearchResultsViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/24/24.
//

import UIKit
import Combine

/// Displays all search results paginated.
final class AllSearchResultsViewController: UITableViewController {
  
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
  
  private let allSearchViewModel: AllSearchViewModel
  
  var liveSearchViewModel: LiveSearchViewModel!
  
  private var cancellables = Set<AnyCancellable>()
  
  private var dataSource: UITableViewDiffableDataSource<Int, ProductPreviewSearchViewModel>!
      
  init(allSearchViewModel: AllSearchViewModel) {
    self.allSearchViewModel = allSearchViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setDataSource()
    setBindings()
    downloadAllSearchResults()
  }
  
  private func setupView() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), primaryAction: UIAction { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    })
    navigationItem.leftBarButtonItem?.tintColor = .label
    
    tableView.register(ProductPreviewSearchTableViewCell.self, forCellReuseIdentifier: ProductPreviewSearchTableViewCell.id)
    
    // Static search bar. Just for displaying the current search. When tapped, the user is sent back
    // to the previous screen.
    let searchBar = UISearchBar()
    searchBar.delegate = self
    searchBar.text = allSearchViewModel.currentSearch
    
    navigationItem.titleView = searchBar
    
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
    allSearchViewModel.$allSearchResults
      .receive(on: DispatchQueue.main)
      .sink { [weak self] products in
        self?.noSearchResultsButton.isHidden = !products.isEmpty
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
  
  private func downloadAllSearchResults() {
    allSearchViewModel.downloadAllSearchResults()
  }
}

// MARK: Search bar delegate

extension AllSearchResultsViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    liveSearchViewModel.shouldAutomaticallyOpenKeyboardOnAppear = true
    navigationController?.popViewController(animated: true)
  }
}

// MARK: UITableViewDelegate

extension AllSearchResultsViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height / 5.0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedProduct = allSearchViewModel.allSearchResults[indexPath.row].product
    let vc = ProductSelectedViewController(product: selectedProduct)
    navigationController?.pushViewController(vc, animated: true)
  }
}
