//
//  AlertHelpers.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation
import UIKit

extension UIViewController {
  
  /// Shows a custom alert from the bottom of the screen
  func showAlertFromBottom(message: String, messageContext: MessageType) {
    let alert = BottomAlertView()
    
    alert.translatesAutoresizingMaskIntoConstraints = false
    
    alert.configure(message: message, messageType: messageContext)
    
    alert.transform = CGAffineTransform(translationX: 0, y: alert.frame.height)
    
    view.addSubview(alert)
    NSLayoutConstraint.activate([
      alert.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      alert.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44.0),
      alert.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      alert.heightAnchor.constraint(equalToConstant: 50.0)
    ])

    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
      alert.transform = .identity
    }, completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        UIView.animate(withDuration: 0.5, animations: {
          alert.alpha = 0.0
        }, completion: { _ in
          alert.removeFromSuperview()
        })
      }
    })
  }
}
