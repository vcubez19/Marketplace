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

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private let maximumScale: CGFloat = 4

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    AsyncImage(url: URL(string: urlString)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )
                                .scaleEffect(scale)
                                .offset(offset)
                                .contentShape(Rectangle())
                                .gesture(
                                    MagnifyGesture()
                                        .onChanged { value in
                                            scale = min(
                                                max(
                                                    lastScale * value.magnification,
                                                    1
                                                ),
                                                maximumScale
                                            )
                                        }
                                        .onEnded { _ in
                                            if scale <= 1 {
                                                scale = 1
                                                offset = .zero
                                                lastOffset = .zero
                                            } else {
                                                offset = clampedOffset(
                                                    offset,
                                                    scale: scale,
                                                    size: geometry.size
                                                )
                                                lastOffset = offset
                                            }

                                            lastScale = scale
                                        }
                                )
                                .simultaneousGesture(
                                    DragGesture()
                                        .onChanged { value in
                                            guard scale > 1 else { return }

                                            offset = clampedOffset(
                                                CGSize(
                                                    width: lastOffset.width
                                                        + value.translation.width,
                                                    height: lastOffset.height
                                                        + value.translation.height
                                                ),
                                                scale: scale,
                                                size: geometry.size
                                            )
                                        }
                                        .onEnded { _ in
                                            lastOffset = offset
                                        }
                                )
                                .onTapGesture(count: 2) { location in
                                    withAnimation(.spring(response: 0.3)) {
                                        if scale > 1 {
                                            scale = 1
                                            lastScale = 1
                                            offset = .zero
                                            lastOffset = .zero
                                        } else {
                                            let newScale: CGFloat = 2

                                            // Move the tapped point toward
                                            // the center as the image zooms.
                                            offset = CGSize(
                                                width: (geometry.size.width / 2
                                                    - location.x) * (newScale - 1),
                                                height: (geometry.size.height / 2
                                                    - location.y) * (newScale - 1)
                                            )

                                            scale = newScale
                                            lastScale = newScale

                                            offset = clampedOffset(
                                                offset,
                                                scale: newScale,
                                                size: geometry.size
                                            )
                                            lastOffset = offset
                                        }
                                    }
                                }

                        case .empty:
                            ProgressView()

                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)

                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }

    private func clampedOffset(
        _ offset: CGSize,
        scale: CGFloat,
        size: CGSize
    ) -> CGSize {
        let maxX = size.width * (scale - 1) / 2
        let maxY = size.height * (scale - 1) / 2

        return CGSize(
            width: min(max(offset.width, -maxX), maxX),
            height: min(max(offset.height, -maxY), maxY)
        )
    }
}

#Preview {
  ProductImageView(urlString: "https://cdn.dummyjson.com/product-images/8/1.jpg")
}
