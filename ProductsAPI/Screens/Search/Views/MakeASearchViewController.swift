//
//  MakeASearchViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import UIKit
import Combine

/// Contains search history and allows users to make new searches
final class MakeASearchViewController: UITableViewController {

  // MARK: Stored properties
  
  private let searchViewModel: SearchViewModel = SearchViewModel()
  
  private var cancellables = Set<AnyCancellable>()
  
  private var dataSource: UITableViewDiffableDataSource<Int, String>!
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setDataSource()
    setBindings()
    downloadSearchHistory()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    navigationItem.searchController?.isActive = true
  }
  
  // MARK: Methods
  
  private func setupView() {
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    let searchResultsController = SearchResultsViewController()
    
    searchResultsController.viewModel = searchViewModel
    
    let searchController = UISearchController(searchResultsController: searchResultsController)
    
    navigationItem.searchController = searchController
    
    searchController.delegate = self
    
    view.backgroundColor = .systemBackground
  }
  
  private func setDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                               cellProvider: { tableView, indexPath, search in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      var content = cell.defaultContentConfiguration()
      
      content.text = search
      
      cell.contentConfiguration = content
      
      var deleteSearchButtonConfiguration = UIButton.Configuration.plain()
      deleteSearchButtonConfiguration.image = UIImage(systemName: "xmark")
      deleteSearchButtonConfiguration.baseForegroundColor = .white
      
      let deleteSearchButton: UIButton = UIButton(type: .system, primaryAction: UIAction { _ in
        print("Tapped delete a search")
      })
      deleteSearchButton.frame = CGRect(x: cell.frame.width - 22.0, y: 0.0, width: 22.0, height: 22.0)
      deleteSearchButton.configuration = deleteSearchButtonConfiguration
      
      cell.accessoryView = deleteSearchButton
            
      return cell
    })
  }
  
  private func setBindings() {
    searchViewModel.$searchHistory
      .receive(on: DispatchQueue.main)
      .sink { [weak self] searches in
        self?.applySnapshot(searches)
      }
      .store(in: &cancellables)
  }
  
  private func applySnapshot(_ searchHistoryItems: [String]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
    
    snapshot.appendSections([0])
    snapshot.appendItems(searchHistoryItems)
    
    dataSource.apply(snapshot)
  }
  
  private func downloadSearchHistory() {
    searchViewModel.downloadSearchHistory()
  }
}

// MARK: UISearchControllerDelegate

extension MakeASearchViewController: UISearchControllerDelegate {
  func didPresentSearchController(_ searchController: UISearchController) {
    DispatchQueue.main.async {
      searchController.searchBar.becomeFirstResponder()
    }
  }
}

// MARK: UITableViewDelegate

extension MakeASearchViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
}
