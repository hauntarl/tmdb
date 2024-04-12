//
//  ImageCache.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//
//  Caching Images:
//  https://grokkingswift.io/caching-strategies-for-ios-applications/

import SwiftUI

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


