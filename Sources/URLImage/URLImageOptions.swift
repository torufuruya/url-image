//
//  URLImageOptions.swift
//  
//
//  Created by Dmytro Anokhin on 02/10/2020.
//

import Foundation
import CoreGraphics


/// Options to control how the image is downloaded and stored
public struct URLImageOptions {

    public enum CachePolicy {

        /// Return an image from cache or download it
        ///
        /// - `cacheDelay`: delay before accessing disk cache.
        /// - `downloadDelay`: delay before starting download.
        ///
        /// There is no delay for in memory cache lookup.
        case returnCacheElseLoad(cacheDelay: TimeInterval? = nil, downloadDelay: TimeInterval? = nil)

        /// Return an image from cache, do not download it
        ///
        /// - `delay`: delay before accessing disk cache.
        ///
        /// There is no delay for in memory cache lookup.
        case returnCacheDontLoad(delay: TimeInterval? = nil)

        /// Ignore cached image and download remote one
        ///
        /// - `delay`: delay before starting download.
        case ignoreCache(delay: TimeInterval? = nil)
    }

    /// Controls how download starts and when it can be cancelled
    public struct LoadOptions: OptionSet {

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Start load when the image view is created
        public static let loadImmediately: LoadOptions = .init(rawValue: 1 << 0)

        /// Start load when the image view appears
        public static let loadOnAppear: LoadOptions = .init(rawValue: 1 << 1)

        /// Cancel load when the image view disappears
        public static let cancelOnDisappear: LoadOptions = .init(rawValue: 1 << 2)

        /// Download image data in memory
        public static let inMemory: LoadOptions = .init(rawValue: 1 << 3)
    }

    /// Unique identifier used to identify an image in cache.
    ///
    /// By default an image is identified by its URL. This is useful for static resources that have persistent URLs.
    /// For images that don't have a persistent URL create an identifier and store it with your model.
    ///
    /// Note: do not use sensitive information as identifier, the cache is stored in a non-encrypted database on disk.
    public var identifier: String?

    /// Time interval after which the cached image expires and can be deleted.
    public var expiryInterval: TimeInterval?

    /// The cache policy controls how the image loaded from cache
    public var cachePolicy: CachePolicy

    public var loadOptions: LoadOptions

    /// Maximum size of a decoded image in pixels. If this property is not specified, the width and height of a decoded is not limited and may be as big as the image itself.
    public var maxPixelSize: CGSize?

    public init(identifier: String? = nil,
                expireAfter expiryInterval: TimeInterval? = URLImageService.shared.defaultOptions.expiryInterval,
                cachePolicy: CachePolicy = URLImageService.shared.defaultOptions.cachePolicy,
                load loadOptions: LoadOptions = URLImageService.shared.defaultOptions.loadOptions,
                maxPixelSize: CGSize? = URLImageService.shared.defaultOptions.maxPixelSize) {
        self.identifier = identifier
        self.expiryInterval = expiryInterval
        self.cachePolicy = cachePolicy
        self.loadOptions = loadOptions
        self.maxPixelSize = maxPixelSize
    }
}
