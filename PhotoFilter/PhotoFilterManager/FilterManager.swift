//
//  FilterManager.swift
//  PhotoFilter
//
//  Created by Sheen on 10/23/24.
//

import Foundation
import CoreImage
import UIKit

protocol  FilterManaging {
    /// Return all the available filters
    var filters: [Filter] { get }
    /// Applying a filter to image
    func applyFilter(image: CIImage, filter: Filter) async throws -> UIImage
}

class FilterManager: FilterManaging {
    
    private let context: CIContext = CIContext.init(options: nil)
    
    var filters: [Filter]  {
        Filter.allCases
    }
    
    func applyFilter(image: CIImage, filter: Filter) async throws -> UIImage {
        let parameters = [kCIInputImageKey: image]
        guard let filter = CIFilter(name: filter.rawValue, parameters: parameters) else {
            throw FilterError.unknownFilter
        }
        guard let outputImage = filter.outputImage else {
            throw FilterError.outputFailed
        }
        guard let uiImage = outputImage.convertToUIImage(context: context) else {
            throw FilterError.convertToUIImageFailed
        }
        return uiImage
    }
}
