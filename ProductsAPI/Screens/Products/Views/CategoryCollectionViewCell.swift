//
//  CategoryCollectionViewCell.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
  
  static let id = "CategoryCollectionViewCell"
  
  // MARK: UI Elements
  
  let categoryButton: UIButton = {
    var configuration = UIButton.Configuration.tinted()
    configuration.cornerStyle = .medium
    
    let button = UIButton(type: .system)
    button.configuration = configuration
    button.isUserInteractionEnabled = false
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: Methods
  
  private func setupView() {
    contentView.addSubview(categoryButton)
    
    NSLayoutConstraint.activate([
      categoryButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
      categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
      categoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
