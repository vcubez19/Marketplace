//
//  ProductSelectedView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/24/24.
//

import SwiftUI

struct ProductSelectedView: View {
  
  let productSelectedViewModel: ProductSelectedViewModel
  
  var body: some View {
    NavigationStack {
      VStack {
        AsyncImage(url: URL(string: productSelectedViewModel.product.thumbnail)!)
          .aspectRatio(contentMode: .fit)
        LazyHStack {
          ForEach(productSelectedViewModel.product.images, id: \.self) { image in
            AsyncImage(url: URL(string: image)!)
              .frame(width: 20.0, height: 20.0)
          }
        }
        Spacer()
      }
    }
  }
}

#Preview {
    ProductSelectedView(productSelectedViewModel: ProductSelectedViewModel(product: Product(id: 0, title: "Test", description: "Test", price: 70, discountPercentage: 80, rating: 5, stock: 55, brand: "Test", category: "Test", thumbnail: "https://cdn.dummyjson.com/product-images/8/1.jpg", images: [
      "https://cdn.dummyjson.com/product-images/8/1.jpg",
      "https://cdn.dummyjson.com/product-images/8/2.jpg",
      "https://cdn.dummyjson.com/product-images/8/3.jpg"
  ])))
}
