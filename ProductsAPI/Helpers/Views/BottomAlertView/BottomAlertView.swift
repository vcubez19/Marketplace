//
//  BottomAlertView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import UIKit

final class BottomAlertView: UIView {

  // MARK: Subviews
  
  private let sideLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 15.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
   fatalError()
  }
  
  func configure(message: String, messageType: MessageType) {
    backgroundColor = .systemGray
    
    clipsToBounds = true
    layer.cornerRadius = 8.0
    layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    
    addSubview(sideLine)
    addSubview(messageLabel)
    
    NSLayoutConstraint.activate([
      sideLine.topAnchor.constraint(equalTo: topAnchor),
      sideLine.leadingAnchor.constraint(equalTo: leadingAnchor),
      sideLine.bottomAnchor.constraint(equalTo: bottomAnchor),
      sideLine.widthAnchor.constraint(equalToConstant: 10.0),
      
      messageLabel.leadingAnchor.constraint(equalTo: sideLine.trailingAnchor, constant: 12.0),
      messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    messageLabel.text = message
    sideLine.backgroundColor = messageType == .success ? .green : .red
  }
}
