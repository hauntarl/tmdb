//
//  NetworkImage.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

/**
 An alternative to `AsyncImage` view. This view utilizes a custom `ImageCache` object to 
 cache network images for fast retrieval of images through app.
 
 - Parameters:
    - url: Location of the image over the internet
    - imageCache: The `ImageCache` object that should be used to store/retrieve cached images
    - content: View to display once the image from `url` is available to use
    - placeholder: View to display while the image is getting loaded from the `url`
 */
struct NetworkImage<I: View, P: View>: View {
    let url: URL?
    var imageCache = ImageCache.shared
    @ViewBuilder let content: (Image) -> I
    @ViewBuilder let placeholder: () -> P
    
    @Environment(\.animationDuration) var animationDuration
    @State private var image: Image?
    
    var body: some View {
        if let url, let uiImage = imageCache.image(for: url.absoluteString) {
            // Directly display the image from cache, reduces fractional overhead
            // of async functions, as they get executed by SwiftUI after all synchronous
            // tasks are completed.
            content(Image(uiImage: uiImage))
                .transition(.blurReplace)
        } else if let image {
            // Display image once it's available
            content(image)
                .transition(.blurReplace)
        } else {
            // Display placeholder and fetch image from the network
            placeholder()
                .transition(.blurReplace)
                .task { await fetchImage() }
        }
    }
    
    private func fetchImage() async {
        guard let uiImage = await imageCache.loadImage(from: url) else {
            return
        }
        
        withAnimation(.easeOut(duration: animationDuration)) {
            image = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    let url =  URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!
    return NetworkImage(url: url) { image in
        image
            .resizable()
            .scaledToFit()
    } placeholder: {
        ProgressView()
    }
    .preferredColorScheme(.dark)
    .animationDuration(1)
}
