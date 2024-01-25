//
//  ProductSelectedView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/25/24.
//

import SwiftUI

struct ProductSelectedView: View {
  
  @State private var selectedImageIndex: Int = 0
  @State private var selectedImageUrlString: String? = nil
  @State private var isModalPresented: Bool = false
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10.0) {
      AsyncImage(url: URL(string: selectedImageUrlString ?? "https://cdn.dummyjson.com/product-images/8/1.jpg")!) { image in
          image
            .resizable()
            .scaledToFit()
      } placeholder: {
          Color.gray.opacity(0.1)
      }
      .frame(height: 200.0)
      .onTapGesture {
        isModalPresented.toggle()
      }
      
      ScrollView {
        VStack(alignment: .leading) {
          LazyHStack {
            ForEach(0..<3) { index in
              AsyncImage(url: URL(string: "https://cdn.dummyjson.com/product-images/8/\(index).jpg")!) { image in
                  image
                    .resizable()
                    .scaledToFit()
              } placeholder: {
                  Color.gray.opacity(0.1)
              }
              .border(selectedImageIndex == index ? Color(uiColor: .label) : .clear, width: 4)
              .cornerRadius(8.0)
              .frame(width: 80.0, height: 80.0)
              .onTapGesture {
                selectedImageIndex = index
                selectedImageUrlString = "https://cdn.dummyjson.com/product-images/8/\(index).jpg"
              }
            }
          }
        }
          .frame(maxWidth: .infinity, alignment: .leading)
      }
        .frame(height: 80.0)
        .frame(maxWidth: .infinity)
      
      
      Text("Test")
        .bold()
        .font(.title2)
      
      Text("$\(69)")
        .bold()
        .font(.title3)
      
      Text("Description")
        .padding(.top)
        .font(.body)
      
      Text("About this item")
        .padding(.top)
        .bold()
        .font(.title2)
      
      HStack(spacing: 20.0) {
        VStack(alignment: .leading, spacing: 20.0) {
          Text("Brand")
            .font(.footnote)
            .foregroundStyle(.gray)
          
          Text("Quanity")
            .font(.footnote)
            .foregroundStyle(.gray)
          
          Text("Original price")
            .font(.footnote)
            .foregroundStyle(.gray)
        }
        
        VStack(alignment: .leading, spacing: 20.0) {
          Text("Apple")
            .bold()
            .font(.footnote)
          
          Text("\(69)")
            .bold()
            .font(.footnote)
          
          Text("$\(13777)")
            .bold()
            .font(.footnote)
        }
      }
        .padding(.top)

      Spacer()
    }
    .padding(.leading)
    .fullScreenCover(isPresented: $isModalPresented) {
      ProductImageView(urlString: "https://cdn.dummyjson.com/product-images/8/1.jpg")
    }
  }
}

#Preview {
  ProductSelectedView()
}
