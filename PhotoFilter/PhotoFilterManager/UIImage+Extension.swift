//
//  CIImage+UIImage.swift
//  PhotoFilter
//
//  Created by Sheen on 10/27/24.
//

import Foundation
import CoreImage
import UIKit
import CommonCrypto

extension CIImage {
    
    func convertToUIImage(context: CIContext) -> UIImage?
    {
        guard let cgImage = context.createCGImage(self, from: self.extent) else {
            return nil
        }
        let image = UIImage(cgImage: cgImage)
        return image
    }
}

extension UIImage {
    
    func sha256() -> String {
        if let imageData = cgImage?.dataProvider?.data as? Data {
            return hexStringFromData(input: digest(input: imageData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
            @unknown default: self = .up
        }
    }
}
