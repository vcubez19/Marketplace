//
//  ProductPreviewSearchTableViewCell.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import UIKit

final class ProductPreviewSearchTableViewCell: UITableViewCell {

  static let id = "ProductPreviewSearchTableViewCell"
  
  // MARK: Subviews
  
  private let thumbnailView: UIImageView = {
    let view = UIImageView()
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    view.layer.cornerRadius = 8.0
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private let productTitleLabel: UILabel = {
    let label = UILabel()
    label.setLineSpacing(lineSpacing: 1.5)
    label.font = UIFont.systemFont(ofSize: 16.0)
    label.numberOfLines = 3
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let brandLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12.0)
    label.textColor = .gray
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let originalPriceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12.0)
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let discountPercentageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 12.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12.0)
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func layout() {
    contentView.addSubview(thumbnailView)
    contentView.addSubview(productTitleLabel)
    contentView.addSubview(brandLabel)
    contentView.addSubview(priceLabel)
    contentView.addSubview(originalPriceLabel)
    contentView.addSubview(discountPercentageLabel)
    contentView.addSubview(stockLabel)
    
    NSLayoutConstraint.activate([
      thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
      thumbnailView.widthAnchor.constraint(equalToConstant: contentView.frame.width / 3.0),
      thumbnailView.heightAnchor.constraint(equalToConstant: 120.0),
      thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      productTitleLabel.topAnchor.constraint(equalTo: thumbnailView.topAnchor),
      productTitleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 8.0),
      productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
      
      brandLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 4.0),
      brandLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
      
      priceLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8.0),
      priceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      
      originalPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4.0),
      originalPriceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      
      discountPercentageLabel.leadingAnchor.constraint(equalTo: originalPriceLabel.trailingAnchor, constant: 4.0),
      discountPercentageLabel.centerYAnchor.constraint(equalTo: originalPriceLabel.centerYAnchor),
      
      stockLabel.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
      stockLabel.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor)
    ])
  }
  
  func configure(with product: ProductPreviewSearchViewModel) {
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
    
    productTitleLabel.text = product.title
    brandLabel.text = product.brandText
    priceLabel.text = product.currentPriceText
    
    // Strikethrough for original price text
    let attributedOriginalPriceText: NSMutableAttributedString =  NSMutableAttributedString(string: "\(product.originalPriceText)")
    attributedOriginalPriceText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedOriginalPriceText.length))
    
    originalPriceLabel.attributedText = attributedOriginalPriceText
    discountPercentageLabel.text = product.discountPercentageText
    stockLabel.text = product.stockText
  }
}
