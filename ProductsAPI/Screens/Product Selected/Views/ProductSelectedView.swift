//
//  ProductSelectedView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/25/24.
//

import SwiftUI

struct ProductSelectedView: View {
  
  let product: Product
  
  @State private var selectedImageIndex: Int = 0
  @State private var selectedImageUrlString: String? = nil
  @State private var isModalPresented: Bool = false
  @State private var addedProductToCart: Bool = false
  @State private var numberOfThisProductInCart: Int = 0
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 10.0) {
        AsyncImage(url: URL(string: selectedImageUrlString ?? "\(product.thumbnail)")!) { image in
          image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
        } placeholder: {
          Color.gray.opacity(0.1)
        }
        .frame(height: 200.0)
        .onTapGesture {
          isModalPresented.toggle()
        }
        
        ScrollViewReader { scrollView in
          ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading) {
              HStack(spacing: 8.0) {
                ForEach(0..<product.imagesWithThumbnailFirst.count, id: \.self) { index in
                  AsyncImage(url: URL(string: product.imagesWithThumbnailFirst[index])!) { image in
                    image
                      .resizable()
                      .scaledToFill()
                      .frame(width: 80.0, height: 80.0)
                  } placeholder: {
                    Color.gray.opacity(0.1)
                  }
                  .aspectRatio(contentMode: .fill)
                  .border(selectedImageIndex == index ? Color(uiColor: .label) : .clear, width: 4)
                  .cornerRadius(8.0)
                  .frame(width: 80.0, height: 80.0)
                  .onTapGesture {
                    selectedImageIndex = index
                    selectedImageUrlString = "\(product.imagesWithThumbnailFirst[index])"
                    
                    withAnimation {
                      selectedImageIndex = index
                      scrollView.scrollTo(index, anchor: .center)
                    }
                  }
                  .id(index)
                  
                }
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
          .frame(height: 80.0)
          .frame(maxWidth: .infinity)
        }
        
        Text(product.title)
          .bold()
          .font(.title2)
        
        Text("$\(product.price)")
          .bold()
          .font(.title3)
        
        Text(product.description)
          .padding(.top)
          .font(.body)
          .lineLimit(nil)
        
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
            Text(product.brand)
              .bold()
              .font(.footnote)
            
            Text("\(product.stock)")
              .bold()
              .font(.footnote)
            
            HStack(spacing: 10.0) {
              Text("$\(product.originalPrice)")
                .bold()
                .font(.footnote)
              
              Text("\(Int(product.discountPercentage))% off!")
                .bold()
                .font(.footnote)
                .padding(4.0)
                .background(.blue)
                .clipShape(Capsule())
            }
          }
        }
        .padding(.top)
        
        Spacer()
        
        if addedProductToCart {
          HStack {
            Button {
              addedProductToCart.toggle()
              numberOfThisProductInCart = 0
            } label: {
              Text("Remove from Cart")
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(.purple)
                .clipShape(Capsule())
            }
            
            Button {
              numberOfThisProductInCart += 1
            } label: {
              ZStack(alignment: .leading) {
                Text("Add Another")
                  .bold()
                  .padding()
                  .frame(maxWidth: .infinity)
                  .foregroundStyle(.white)
                  .background(.blue)
                  .clipShape(Capsule())
                Image(systemName: "\(numberOfThisProductInCart).circle.fill")
                  .foregroundStyle(.white)
                  .offset(x: 12.0)
              }
            }
          }
          .transition(.move(edge: .bottom))
          .animation(.easeInOut)
        } else {
          Button {
            withAnimation {
              addedProductToCart.toggle()
              numberOfThisProductInCart += 1
            }
          } label: {
            Text("Add to Cart")
              .bold()
              .padding()
              .frame(maxWidth: .infinity)
              .foregroundStyle(.white)
              .background(.indigo)
              .clipShape(Capsule())
          }
          .transition(.move(edge: .bottom))
          .animation(.easeInOut)
        }
      }
      
      .padding(.leading)
      .fullScreenCover(isPresented: $isModalPresented) {
        ProductImageView(urlString: selectedImageUrlString ?? product.thumbnail)
      }
    }
  }
}

#Preview {
  ProductSelectedView(product: TestProductsService.shared.products.randomElement()!)
}
