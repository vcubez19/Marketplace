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

  // MARK: UI Elements
  
  private let noSearchHistoryButton: UIButton = {
    
    var configuration = UIButton.Configuration.plain()
    
    configuration.title = "No search history"
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
  
  private let searchViewModel: LiveSearchViewModel = LiveSearchViewModel()
  
  private var cancellables = Set<AnyCancellable>()
  
  private var dataSource: UITableViewDiffableDataSource<Int, Search>!
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setDataSource()
    setBindings()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    downloadSearchHistory()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    navigationItem.searchController?.isActive = searchViewModel.shouldAutomaticallyOpenKeyboardOnAppear
    DispatchQueue.main.async {
      if self.searchViewModel.shouldAutomaticallyOpenKeyboardOnAppear {
        self.navigationItem.searchController?.searchBar.becomeFirstResponder()
      } else {
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
      }
    }
  }
  
  // MARK: Methods
  
  private func setupView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    let searchResultsController = LiveSearchResultsViewController()
    
    searchResultsController.viewModel = searchViewModel
    
    let searchController = UISearchController(searchResultsController: searchResultsController)
    
    navigationItem.searchController = searchController
    
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.searchBar.autocapitalizationType = .none
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(noSearchHistoryButton)
    
    NSLayoutConstraint.activate([
      noSearchHistoryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
      noSearchHistoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  private func setDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                               cellProvider: { tableView, indexPath, search in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      var content = cell.defaultContentConfiguration()
      
      content.text = search.searchText
      
      cell.contentConfiguration = content
      
      var deleteSearchButtonConfiguration = UIButton.Configuration.plain()
      deleteSearchButtonConfiguration.image = UIImage(systemName: "xmark")
      deleteSearchButtonConfiguration.baseForegroundColor = .white
      
      let deleteSearchButton: UIButton = UIButton(type: .system, primaryAction: UIAction { [unowned self] _ in
        self.searchViewModel.deleteSearchAtIndex(indexPath.row)
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
        self?.noSearchHistoryButton.isHidden = !searches.isEmpty
        self?.applySnapshot(searches)
      }
      .store(in: &cancellables)
    
    searchViewModel.$searchHistoryErrorMessage
      .receive(on: DispatchQueue.main)
      .sink { [weak self] message in
        guard let message = message else { return }
        self?.showAlertFromBottom(message: message, messageContext: .error)
      }
      .store(in: &cancellables)
  }
  
  private func applySnapshot(_ searchHistoryItems: [Search]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Search>()
    
    snapshot.appendSections([0])
    snapshot.appendItems(searchHistoryItems)
    
    dataSource.apply(snapshot)
  }
  
  private func downloadSearchHistory() {
    searchViewModel.downloadSearchHistory()
  }
  
  private func moveToAllSearchResultsVc(search: String) {
    let allSearchResultsVc = AllSearchResultsViewController(allSearchViewModel: AllSearchViewModel(search: search))
    allSearchResultsVc.liveSearchViewModel = searchViewModel
    navigationController?.pushViewController(allSearchResultsVc, animated: true)
  }
}

// MARK: Search delegate methods

extension MakeASearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchViewModel.saveNewSearch()
    
    searchViewModel.shouldAutomaticallyOpenKeyboardOnAppear = true

    moveToAllSearchResultsVc(search: searchViewModel.searchText)
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    searchViewModel.searchText = searchController.searchBar.text ?? ""
  }
}

// MARK: UITableViewDelegate

extension MakeASearchViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    searchViewModel.shouldAutomaticallyOpenKeyboardOnAppear = false
    moveToAllSearchResultsVc(search: searchViewModel.searchHistory[indexPath.row].searchText!)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
}
