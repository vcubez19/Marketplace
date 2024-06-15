//
//  extensions.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation
import UIKit

// MARK: UILabel

extension UILabel {
  func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
    guard let labelText = self.text else { return }

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineHeightMultiple = lineHeightMultiple

    let attributedString:NSMutableAttributedString
    if let labelattributedText = self.attributedText {
        attributedString = NSMutableAttributedString(attributedString: labelattributedText)
    } else {
        attributedString = NSMutableAttributedString(string: labelText)
    }

    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

    self.attributedText = attributedString
  }
}

// MARK: Double

extension Double {
  func rounded(toPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
