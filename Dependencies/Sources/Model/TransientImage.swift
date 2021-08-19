//
//  TransientImage.swift
//  
//
//  Created by Dmytro Anokhin on 08/01/2021.
//

import Foundation
import ImageIO
import ImageDecoder


/// Temporary representation used after decoding an image from data or file on disk and before creating an image object for display.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct TransientImage {
    
    public var cgImages: [CGImage] {
        return proxy.cgImages
    }
    
    public var animationDuration: TimeInterval {
        return proxy.animationDuration
    }

    public let info: ImageInfo

    /// The uniform type identifier (UTI) of the source image.
    ///
    /// See [Uniform Type Identifier Concepts](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html#//apple_ref/doc/uid/TP40001319-CH202) for a list of system-declared and third-party UTIs.
    public let uti: String

    public let cgOrientation: CGImagePropertyOrientation

    init(proxy: CGImageProxy, info: ImageInfo, uti: String, cgOrientation: CGImagePropertyOrientation) {
        self.proxy = proxy
        self.info = info
        self.uti = uti
        self.cgOrientation = cgOrientation
    }

    private let proxy: CGImageProxy
}


/// Proxy used to decode image lazily
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class CGImageProxy {

    let decoder: ImageDecoder

    let maxPixelSize: CGSize?

    init(decoder: ImageDecoder, maxPixelSize: CGSize?) {
        self.decoder = decoder
        self.maxPixelSize = maxPixelSize
    }
    
    var cgImages: [CGImage] {
        if decodedCGImages == nil {
            decodeImages()
        }

        return decodedCGImages!
    }
    
    private var decodedCGImages: [CGImage]?
    
    private func decodeImages() {
        if let sizeForDrawing = maxPixelSize {
            let decodingOptions = ImageDecoder.DecodingOptions(mode: .asynchronous, sizeForDrawing: sizeForDrawing)
            decodedCGImages = (0..<decoder.frameCount).map { decoder.createFrameImage(at: $0, decodingOptions: decodingOptions)! }
        } else {
            decodedCGImages = (0..<decoder.frameCount).map { decoder.createFrameImage(at: $0)! }
        }
    }
    
    var animationDuration: TimeInterval {
        return (0..<decoder.frameCount)
            .map { decoder.frameDuration(at: $0) ?? 0 }
            .reduce(.zero, +)
    }
}
