//
//  ProductSelectedView.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/25/24.
//

import SwiftUI

struct ProductSelectedView: View {
    let product: Product

    @State private var selectedImageIndex = 0
    @State private var selectedImageUrlString: String?
    @State private var isModalPresented = false
    @State private var numberOfThisProductInCart = 0

    @Environment(\.dismiss) private var dismiss

    private var productInsideCart: Bool {
        numberOfThisProductInCart > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    productImage
                    imageGallery
                    productDetails
                    productInformation
                    Spacer(minLength: 0)
                    cartControls
                }
                .padding(.horizontal)
            }
            .fullScreenCover(isPresented: $isModalPresented) {
                ProductImageView(
                    urlString: selectedImageUrlString ?? product.thumbnail
                )
            }
        }
    }

    // MARK: - Product Images

    private var productImage: some View {
        AsyncImage(
            url: URL(string: selectedImageUrlString ?? product.thumbnail)
        ) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        } placeholder: {
            Color.gray.opacity(0.1)
        }
        .frame(height: 200)
        .contentShape(Rectangle())
        .onTapGesture {
            isModalPresented = true
        }
        .transaction { transaction in
            transaction.animation = nil
        }
    }

    private var imageGallery: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(
                        product.images.indices,
                        id: \.self
                    ) { index in
                        imageThumbnail(at: index)
                            .id(index)
                            .onTapGesture {
                                selectImage(at: index, using: scrollView)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 80)
        }
    }

    private func imageThumbnail(at index: Int) -> some View {
        AsyncImage(
            url: URL(
                string: product.images[index]
            )
        ) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.1)
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    selectedImageIndex == index
                        ? Color(uiColor: .label)
                        : Color.gray.opacity(0.2),
                    lineWidth: selectedImageIndex == index ? 2.5 : 1
                )
        }
        .shadow(
            color: selectedImageIndex == index
                ? Color.indigo.opacity(0.2)
                : .clear,
            radius: 4,
            y: 2
        )
        .animation(.easeInOut(duration: 0.2), value: selectedImageIndex)
    }

    private func selectImage(
        at index: Int,
        using scrollView: ScrollViewProxy
    ) {
        guard product.images.indices.contains(index) else {
            return
        }

        selectedImageIndex = index
        selectedImageUrlString = product.images[index]

        withAnimation {
            scrollView.scrollTo(index, anchor: .center)
        }
    }

    // MARK: - Product Details

    private var productDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(product.title)
                .font(.title2)
                .bold()

            Text(product.price.formatPrice())
                .font(.title3)
                .bold()

            Text(product.description)
                .font(.body)
                .lineLimit(nil)
                .padding(.top)

            Text("About this item")
                .font(.title2)
                .bold()
                .padding(.top)
        }
    }

    private var productInformation: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                informationLabel("Brand")
                informationLabel("Quantity")
                informationLabel("Original price")
            }

            VStack(alignment: .leading, spacing: 20) {
                informationValue(product.brandText)
                informationValue("\(product.stock)")

                HStack(spacing: 10) {
                    informationValue(product.originalPrice.formatPrice())

                    discountBadge
                }
            }
        }
        .padding(.top)
    }

    private func informationLabel(_ title: String) -> some View {
        Text(title)
            .font(.footnote)
            .foregroundStyle(.gray)
    }

    private func informationValue(_ value: String) -> some View {
        Text(value)
            .font(.footnote)
            .bold()
    }

    private var discountBadge: some View {
        Text("\(Int(product.discountPercentage))% off!")
            .font(.footnote)
            .bold()
            .padding(4)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }

    // MARK: - Cart Controls

    @ViewBuilder
    private var cartControls: some View {
        if productInsideCart {
            quantitySelector
        } else {
            addToCartButton
        }
    }

    private var quantitySelector: some View {
        HStack(spacing: 50) {
            Spacer()

            quantityButton(
                systemName: "minus.circle.fill",
                action: { numberOfThisProductInCart -= 1 }
            )

            Text("\(numberOfThisProductInCart)")
                .font(.title2)
                .bold()

            quantityButton(
                systemName: "plus.circle.fill",
                action: { numberOfThisProductInCart += 1 }
            )

            Spacer()
        }
        .padding()
    }

    private func quantityButton(
        systemName: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .frame(width: 32, height: 32)
                .symbolRenderingMode(.hierarchical)
                .tint(.white)
                .foregroundStyle(.blue)
        }
    }

    private var addToCartButton: some View {
        Button {
            withAnimation {
                numberOfThisProductInCart = 1
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
        .padding()
    }
}

#Preview {
  ProductSelectedView(product: TestProductsService.shared.products.randomElement()!)
}
