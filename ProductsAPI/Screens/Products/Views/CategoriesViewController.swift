//
//  CategoriesViewController.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import UIKit
import Combine

final class CategoriesViewController: UIViewController {
  
  // MARK: UI Elements
  
  private let categoriesLabel: UILabel = {
    let label = UILabel()
    label.text = "Choose categories"
    label.font = UIFont.boldSystemFont(ofSize: 20.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let categoriesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 12.0, right: 8.0)
    collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
  }()
  
  private let applyFilterButton: UIButton = {
    var configuration = UIButton.Configuration.tinted()
    
    configuration.title = "Apply filter"
    configuration.buttonSize = .large
    configuration.cornerStyle = .medium
    configuration.imagePadding = 8.0
    configuration.imageColorTransformer = UIConfigurationColorTransformer{ _ in
      return UIColor.white
    }
    
    let button = UIButton(type: .system)
    button.configuration = configuration
    button.isEnabled = false
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  // MARK: Stored properties
  
  private let viewModel: CategoriesViewModel = CategoriesViewModel()
  
  private var cancellables = Set<AnyCancellable>()
  
  private var dataSource: UICollectionViewDiffableDataSource<Int, CategoryViewModel>!
  
  // MARK: Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setDataSource()
    setBindings()
    downloadCategories()
  }
  
  // MARK: Methods
  
  private func setupView() {
    view.addSubview(categoriesLabel)
    view.addSubview(categoriesCollectionView)
    view.addSubview(applyFilterButton)
    categoriesCollectionView.delegate = self
    
    NSLayoutConstraint.activate([
      categoriesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 22.0),
      categoriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0),
      
      categoriesCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.0),
      categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      categoriesCollectionView.heightAnchor.constraint(equalToConstant: 60.0),
      
      applyFilterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44.0),
      applyFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      applyFilterButton.heightAnchor.constraint(equalToConstant: 50.0)
    ])
  }
  
  private func setDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: categoriesCollectionView, cellProvider: { collectionView, indexPath, category in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as! CategoryCollectionViewCell
      
      cell.categoryButton.configuration?.title = category.formattedTitle
      cell.categoryButton.configuration?.baseBackgroundColor = category.selected ? .systemBlue : .systemGray
      cell.categoryButton.configuration?.baseForegroundColor = category.selected ? .systemBlue : .systemGray
      
      return cell
    })
  }
  
  private func setBindings() {
    viewModel.$categories
      .receive(on: DispatchQueue.main)
      .sink { [weak self] categories in
        self?.applySnapshot(categories: categories)
      }
      .store(in: &cancellables)
    
    viewModel.$selectedCategories
      .receive(on: DispatchQueue.main)
      .sink { [weak self] selectedCategories in
        self?.applyFilterButton.isEnabled = !selectedCategories.isEmpty

        self?.applyFilterButton.configuration?.image = selectedCategories.isEmpty ? nil : UIImage(systemName: "\(selectedCategories.count).circle.fill")
      }
      .store(in: &cancellables)
  }
  
  private func applySnapshot(categories: [CategoryViewModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, CategoryViewModel>()
    
    snapshot.appendSections([0])
    snapshot.appendItems(categories)
    
    dataSource.apply(snapshot)
  }
  
  private func downloadCategories() {
    viewModel.downloadCategories()
  }
}

// MARK: Collection view delegate

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var snapshot = dataSource.snapshot()
    
    let category = viewModel.categories[indexPath.item]
    
    category.selected.toggle()
    
    if let existingCategory = snapshot.itemIdentifiers.first(where: { $0.title == category.title }) {
      snapshot.reloadItems([existingCategory])
    }

    viewModel.handleSelectedCategory(category)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width / 2.0, height: 50.0)
  }
}
