//
//  ProductPreviewCollectionViewCell.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import UIKit

final class ProductPreviewCollectionViewCell: UICollectionViewCell {
  
  static let id = "ProductPreviewCollectionViewCell"
  
  private let thumbnailView: UIImageView = {
    let view = UIImageView()
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private let productInformationLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 13.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setupView() {
    contentView.addSubview(productInformationLabel)
    contentView.addSubview(thumbnailView)
    
    NSLayoutConstraint.activate([
      productInformationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4.0),
      productInformationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
      productInformationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4.0),
      
      thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      thumbnailView.bottomAnchor.constraint(equalTo: productInformationLabel.topAnchor, constant: -4.0),
      thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor)
    ])
  }
  
  func configure(product: ProductPreviewViewModel) {
    Task {
      let thumbnailData = await product.downloadThumbnail()
      
      if let thumbnailData = thumbnailData {
        thumbnailView.image = UIImage(data: thumbnailData)
      } else {
        Log.error("Failed to download a thumbnail for a product.")
        // Can replace with a failed to load image.
        thumbnailView.image = UIImage()
      }
    }
    
    productInformationLabel.text = product.productInformationText
  }
}
