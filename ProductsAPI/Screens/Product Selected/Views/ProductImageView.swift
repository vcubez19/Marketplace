//
//  ProductImageView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/25/24.
//

import SwiftUI

struct ProductImageView: View {
  
  @Environment(\.dismiss) private var dismiss
  
  let urlString: String
  
  var body: some View {
    NavigationStack {
      VStack {
        AsyncImage(url: URL(string: urlString)!)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button(action: {
                dismiss()
              },
              label: {
                Image(systemName: "xmark.circle.fill")
                  .foregroundStyle(.gray)
              })
            }
          }
      }
    }
  }
}

#Preview {
  ProductImageView(urlString:                 "https://cdn.dummyjson.com/product-images/8/1.jpg")
}
