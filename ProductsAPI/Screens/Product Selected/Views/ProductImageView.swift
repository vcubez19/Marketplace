//
//  ProductImageView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/25/24.
//

import SwiftUI

struct ProductImageView: View {
  
  @Environment(\.dismiss) private var dismiss
  @State private var zoomed = false
  
  let urlString: String
  
  var body: some View {
    NavigationStack {
      VStack {
        ScrollView {
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
            .gesture(
              TapGesture(count: 2)
                .onEnded {
                  withAnimation {
                    zoomed.toggle()
                  }
                }
            )
            .scaleEffect(zoomed ? 2.0 : 1.0)
        }
      }
    }
  }
}

#Preview {
  ProductImageView(urlString: "https://cdn.dummyjson.com/product-images/8/1.jpg")
}
