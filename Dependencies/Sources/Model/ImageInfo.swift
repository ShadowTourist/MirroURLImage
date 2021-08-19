//
//  ImageInfo.swift
//  
//
//  Created by Dmytro Anokhin on 23/12/2020.
//

import CoreGraphics


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct ImageInfo {

    /// Decoded image
    public var cgImages: [CGImage] {
        proxy.cgImages
    }

    /// Image size in pixels.
    ///
    /// This is the real size, that can be different from decoded image size.
    public var size: CGSize

    init(proxy: CGImageProxy, size: CGSize) {
        self.proxy = proxy
        self.size = size
    }

    private let proxy: CGImageProxy
}
