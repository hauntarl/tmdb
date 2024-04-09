//
//  NetworkImage.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//
//  Caching Images:
//  https://grokkingswift.io/caching-strategies-for-ios-applications/

import SwiftUI

/**
 An alternative to `AsyncImage` view. This view utilizes a custom `ImageCache` object to 
 cache network images for fast retrieval of images through app.
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
            // Directly display the image from cache
            content(Image(uiImage: uiImage))
                .transition(.opacity)
        } else if let image {
            // Display image once it's available
            content(image)
                .transition(.opacity)
        } else {
            // Display placeholder and fetch image from the network
            placeholder()
                .transition(.opacity)
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

/**
 `ImageCache` implements an in-memory image caching strategy using `NSCache`.
 
 `NSCache` primarily stores data in memory, meaning the data in NSCache is not saved to
 disk. If your app terminates, the cache is cleared.
 */
class ImageCache {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    static let shared = ImageCache()
    
    private init() {
        cache.countLimit = 200  // Maximum number of objects
        cache.totalCostLimit = 100 * 1024 * 1024  // 100 MB
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    /**
     Helper method that asynchronously fetches one image and caches it
     */
    func loadImage(from url: URL?) async -> UIImage? {
        // If url is nil, return
        guard let url else {
            return nil
        }
        // If image already in cache, return
        if let uiImage = image(for: url.absoluteString) {
            return uiImage
        }
        
        guard
            let (data, _) = try? await URLSession.shared.data(from: url),
            let uiImage = UIImage(data: data)
        else {
            return nil
        }
        setImage(uiImage, for: url.absoluteString)
        return uiImage
    }
    
    /**
     Helper method that caches images from url in bulk
     */
    func loadImages(from urls: [URL?]) async {
        let _ = await withTaskGroup(of: [UIImage].self) { group -> [UIImage] in
            for url in urls {
                group.addTask { [unowned self] in
                    guard let uiImage = await self.loadImage(from: url) else {
                        return []
                    }
                    return [uiImage]
                }
            }
            
            var collected = [UIImage]()
            for await images in group {
                collected.append(contentsOf: images)
            }
            return collected
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
    .animationDuration(0.5)
}
