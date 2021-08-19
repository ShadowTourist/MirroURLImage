//
//  TransientImage.swift
//  
//
//  Created by Dmytro Anokhin on 30/09/2020.
//

import SwiftUI
import Model


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension TransientImage {

    var image: URLImageView {
        return URLImageView(cgImages: self.cgImages, animationDuration: self.animationDuration)
    }
}

public struct URLImageView: View {
    var cgImages: [CGImage]
    var animationDuration: TimeInterval
    
    public var body: some View {
        GIFImageViewRepresentable(cgImages: cgImages, animationDuration: animationDuration)
    }
}

struct GIFImageViewRepresentable: UIViewRepresentable {
    var cgImages: [CGImage]
    var animationDuration: TimeInterval
    
    var images: [UIImage] {
        cgImages.map { UIImage(cgImage: $0) }
    }
    
    func makeUIView(context: Self.Context) -> UIView {
        let imageViewWrapper = UIImageViewWrapper()
        imageViewWrapper.imageView.image = UIImage.animatedImage(with: images, duration: animationDuration)
        return imageViewWrapper
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GIFImageViewRepresentable>) {
    }
}

class UIImageViewWrapper: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.sizeToFit()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        addSubview(imageView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
