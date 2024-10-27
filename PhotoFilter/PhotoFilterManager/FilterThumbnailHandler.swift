//
//  FilterThumbnailHandler.swift
//  PhotoFilter
//
//  Created by Sheen on 10/23/24.
//

import Foundation
import CoreImage
import UIKit

typealias FilterAndThumbnail = [Filter: UIImage]

enum FilterThumbnailError: Error {
    case resizeImageError
}

protocol FilterThumbnailHandling {
    func generateThumbnails(_ filters: [Filter],_ image: CIImage) async throws -> FilterAndThumbnail
}

class FilterThumbnailHandler {

    private let filterManager: FilterManaging
    private let thumbnailSize: Int
    
    init(thumbnailSize: Int = 50,
         filterManager: FilterManaging = FilterManager()) {
        self.filterManager = filterManager
        self.thumbnailSize = thumbnailSize
    }
}

extension FilterThumbnailHandler: FilterThumbnailHandling {
    
    func generateThumbnails(_ filters: [Filter] = Filter.allCases,_ image: CIImage) async throws -> FilterAndThumbnail {
        let targetSize = CGSize(width: thumbnailSize, height: thumbnailSize)
        // Resize the image
        guard let resizeImage = resizeImage(sourceImage: image,
                                            targetSize: targetSize) else {
            throw FilterThumbnailError.resizeImageError
        }
        // Generating thumbnails for the filters
        let filterAndThumbnails = try await withThrowingTaskGroup(of: (Filter, UIImage?).self,
                                                                  returning: FilterAndThumbnail.self) { taskGroup in
            for filter in filters {
                taskGroup.addTask { [weak self] in
                    guard let self else { return (filter, nil) }
                    let image = try await filterManager.applyFilter(image: resizeImage, filter: filter)
                    return (filter, image)
                }
            }
            var filterAndThumbnail = FilterAndThumbnail()
            for try await filterAndImage in taskGroup {
                filterAndThumbnail[filterAndImage.0] = filterAndImage.1
            }
            return filterAndThumbnail
        }
        return filterAndThumbnails
    }
}

private extension FilterThumbnailHandler {
    
    func resizeImage(sourceImage: CIImage, targetSize: CGSize) -> CIImage? {
        guard let resizeFilter = CIFilter(name:"CILanczosScaleTransform") else {
            return nil
        }
        // Compute scale and corrective aspect ratio
        let scale = targetSize.height / (sourceImage.extent.height)
        let aspectRatio = targetSize.width/((sourceImage.extent.width) * scale)
        
        // Apply resizing
        resizeFilter.setValue(sourceImage, forKey: kCIInputImageKey)
        resizeFilter.setValue(scale, forKey: kCIInputScaleKey)
        resizeFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        return resizeFilter.outputImage
    }
}
