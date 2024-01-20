//
//  CategoryViewModel.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/19/24.
//

import Foundation

final class CategoryViewModel: Hashable {
  let title: String
  var selected: Bool = false
  
  init(title: String, selected: Bool = false) {
    self.title = title
    self.selected = selected
  }
  
  var formattedTitle: String {
    return title.replacingOccurrences(of: "-", with: " ")
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(title)
  }

  static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
    return lhs.title == rhs.title
  }
}
