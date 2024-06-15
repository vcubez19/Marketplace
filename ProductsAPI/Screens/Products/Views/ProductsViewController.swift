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
  
  private lazy var categoriesButton: UIButton = {
    
    var configuration = UIButton.Configuration.plain()
    
    configuration.image = UIImage(systemName: "rectangle.3.group")
    configuration.background.backgroundColor = .darkGray
    configuration.imageColorTransformer = UIConfigurationColorTransformer{ color in
      return .white
    }
    configuration.cornerStyle = .capsule
    configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
    
    let button = UIButton(primaryAction: UIAction { [unowned self] _ in
      let vc = CategoriesViewController()
      
      vc.viewModel = self.categoriesViewModel
      vc.delegate = self
      
      if let sheet = vc.sheetPresentationController {
        sheet.prefersGrabberVisible = true
        sheet.detents = [
          .custom { _ in
            return vc.view.frame.height / 3.0
          }
        ]
      }
    
      self.present(vc, animated: true)
    })
    
    button.configuration = configuration
    
    return button
  }()
  
  private lazy var searchButton: UIButton = {
    
    var configuration = UIButton.Configuration.plain()
    
    configuration.image = UIImage(systemName: "magnifyingglass")
    configuration.background.backgroundColor = .darkGray
    configuration.imageColorTransformer = UIConfigurationColorTransformer{ color in
      return .white
    }
    configuration.cornerStyle = .capsule
    configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
    
    let button = UIButton(primaryAction: UIAction { [unowned self] _ in
      let vc = MakeASearchViewController()
      self.navigationController?.pushViewController(vc, animated: true)
    })
    button.configuration = configuration
    
    return button
  }()
  
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
  
  private var dataSource: UICollectionViewDiffableDataSource<Int, ProductPreviewViewModel>!
  
  private var categoriesViewModel: CategoriesViewModel = CategoriesViewModel()
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setDataSource()
    setBindings()
    downloadProducts()
  }
  
  // MARK: Methods
  
  private func setupView() {
    let categoriesBarButton = UIBarButtonItem(customView: categoriesButton)
    let searchBarButton = UIBarButtonItem(customView: searchButton)
    navigationItem.leftBarButtonItem = categoriesBarButton
    navigationItem.rightBarButtonItem = searchBarButton
    
    collectionView.register(ProductPreviewCollectionViewCell.self, forCellWithReuseIdentifier: ProductPreviewCollectionViewCell.id)
    
    view.addSubview(loadingIndicator)
    
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  // MARK: Collection view data source
  
  private func setDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, product in
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductPreviewCollectionViewCell.id, for: indexPath) as! ProductPreviewCollectionViewCell
      
      cell.configure(product: product)
      
      return cell
    })
  }
  
  private func setBindings() {
    viewModel.$products
      .receive(on: DispatchQueue.main)
      .sink { [weak self] products in
        self?.applySnapshot(products: products)
      }
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
  
  private func applySnapshot(products: [ProductPreviewViewModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, ProductPreviewViewModel>()
    
    snapshot.appendSections([0])
    snapshot.appendItems(products)
    
    dataSource.apply(snapshot)
  }
  
  private func downloadProducts() {
    Task {
      await viewModel.downloadProducts()
    }
  }
  
  // MARK: Pagination
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    Task {
      if indexPath.item == viewModel.originalProducts.count - 2 {
        await viewModel.downloadProducts()
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let selectedProduct = viewModel.products[indexPath.row].product
    let vc = ProductSelectedViewController(product: selectedProduct)
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: Collection view delegate

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing: CGFloat = 10.0
    let collectionViewWidth = collectionView.bounds.width
    let itemWidth = (collectionViewWidth - spacing) / 2.0

    return CGSize(width: itemWidth, height: collectionView.frame.height / 3.0)
  }
}

extension ProductsViewController: CategoriesViewControllerDelegate {
  func applyCategoryFilter(_ categories: [CategoryViewModel]) {
    viewModel.applyCategoryFilter(categories.map({ $0.title }))
  }
}
