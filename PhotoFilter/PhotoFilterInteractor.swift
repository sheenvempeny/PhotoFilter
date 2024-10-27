//
//  PhotoFilterInteractor.swift
//  PhotoFilter
//
//  Created by Sheen on 10/22/24.
//

import Foundation
import Observation
import SwiftUI

protocol PhotoEditorInteractable {
    var filters: [Filter] { get }
    var filtersAndThumnails: FilterAndThumbnail { get }
    func loadImageData(data: Data)
    func applyFilter(filter: Filter)
    func resetFilter()
}

@Observable
class PhotoFilterInteractor {
    private(set) var filtersAndThumnails = FilterAndThumbnail()
    private(set) var image: Image?
    private var filterManager: FilterManaging = FilterManager()
    private var filterThumbnailHandler: FilterThumbnailHandling = FilterThumbnailHandler()
    private var thumbnailCache = [String: FilterAndThumbnail]()
    private var originalImage: UIImage? {
        didSet {
            if let originalImage {
                generateThumbnail(uiImage: originalImage)
            }
        }
    }
}

extension PhotoFilterInteractor: PhotoEditorInteractable {
    
    var filters: [Filter] {
        return filterManager.filters
    }
    
    func loadImageData(data: Data) {
        if let uiImage = UIImage(data: data) {
            originalImage = uiImage
            self.image = Image(uiImage: uiImage)
        }
    }
    
    func applyFilter(filter: Filter) {
        guard let originalImage, var ciImage =  CIImage(image: originalImage) else {
            return
        }
        ciImage = ciImage.oriented(.init(originalImage.imageOrientation))
        Task {
            do {
                let uiImage = try await filterManager.applyFilter(image: ciImage, filter: filter)
                self.image = Image(uiImage: uiImage)
            } catch {
                print("\(error)")
            }
        }
    }
    
    func resetFilter() {
        guard let originalImage else {
            return
        }
        self.image = Image(uiImage: originalImage)
    }
}

private extension PhotoFilterInteractor {
    
    func generateThumbnail(uiImage: UIImage) {
        let thumbnailsDictionary = thumbnailCache[uiImage.sha256()]
        guard thumbnailsDictionary?.isEmpty ?? true else {
            self.filtersAndThumnails = thumbnailsDictionary ?? FilterAndThumbnail()
            return
        }
        Task {
            do {
                if var ciImage = CIImage(image: uiImage) {
                    ciImage = ciImage.oriented(.init(uiImage.imageOrientation))
                    let filterAndThumbnails = try await filterThumbnailHandler.generateThumbnails(Filter.allCases, ciImage)
                    thumbnailCache[uiImage.sha256()] = filterAndThumbnails
                    self.filtersAndThumnails = filterAndThumbnails
                }
            } catch {
                print("\(error)")
            }
        }
    }
}

