//
//  ProductSelectedView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/25/24.
//

import SwiftUI

struct ProductSelectedView: View {
  var body: some View {
    VStack {
      AsyncImage(url: URL(string: "https://cdn.dummyjson.com/product-images/8/1.jpg")!) { image in
          image
            .resizable()
            .scaledToFit()
      } placeholder: {
          Color.gray.opacity(0.1)
      }
        .frame(height: 300.0)
      
      Spacer()
    }
  }
}

#Preview {
    ProductSelectedView()
}
