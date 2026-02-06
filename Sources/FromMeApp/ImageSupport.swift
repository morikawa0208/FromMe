import SwiftUI

#if canImport(UIKit)
import UIKit
private typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
private typealias PlatformImage = NSImage
#endif

struct MemoImageView: View {
    let imageData: Data

    var body: some View {
        if let image = PlatformImage(data: imageData) {
            #if canImport(UIKit)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            #elseif canImport(AppKit)
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
            #endif
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay(Text("画像を読み込めませんでした").font(.caption).foregroundStyle(.secondary))
        }
    }
}
