//
//  ProductSelectedView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/24/24.
//

import SwiftUI

struct ProductSelectedView: View {
  
  let productSelectedViewModel: ProductSelectedViewModel
    
  @State private var selectedImageIndex: Int = 0
  @State private var topImageUrlString: String? = nil
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0.0) {
        AsyncImage(url: URL(string: topImageUrlString ?? productSelectedViewModel.product.thumbnail)!)
          .aspectRatio(contentMode: .fit)
          .onAppear {
            topImageUrlString = productSelectedViewModel.product.thumbnail
          }
        HStack {
          ScrollView {
            LazyHStack {
              ForEach(0..<productSelectedViewModel.product.images.count, id: \.self) { index in
                AsyncImage(url: URL(string: productSelectedViewModel.product.images[index])!,
                           content: { image in
                              image.resizable()
                              .border(selectedImageIndex == index ? Color(UIColor.label) : Color.clear, width: 4)
                                .onTapGesture {
                                  selectedImageIndex = index
                                  topImageUrlString = productSelectedViewModel.product.images[index]
                                }
                              .aspectRatio(contentMode: .fit)
                              .cornerRadius(8.0)
                              .frame(maxWidth: 100.0, maxHeight: 100.0)
                           },
                           placeholder: {
                            ProgressView()
                           })
              }
            }
          }
          .padding(.leading)
          Spacer()
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
//      "https://cdn.dummyjson.com/product-images/8/3.jpg"
  ])))
}
