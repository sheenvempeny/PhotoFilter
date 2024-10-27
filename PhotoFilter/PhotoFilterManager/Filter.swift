//
//  Filter.swift
//  PhotoFilter
//
//  Created by Sheen on 10/23/24.
//

import Foundation

enum FilterError: Error {
    case unknownFilter
    case outputFailed
    case convertToUIImageFailed
}

enum Filter: String, CaseIterable {
    case sepia
    case chrome
    case fade
    case invert
    case posterize
    case sketch
    case comic
    case crystal
}

extension Filter {
    var rawValue: String {
        var returnValue = ""
        switch self {
        case .sepia:
            returnValue = "CISepiaTone"
        case .chrome:
            returnValue =  "CIPhotoEffectChrome"
        case .fade:
            returnValue =  "CIPhotoEffectInstant"
        case .invert:
            returnValue =  "CIColorInvert"
        case .posterize:
            returnValue =  "CIColorPosterize"
        case .sketch:
            returnValue =  "CILineOverlay"
        case .comic:
            returnValue =  "CIComicEffect"
        case .crystal:
            returnValue =  "CICrystallize"
        }
        return returnValue
    }
    
    var displayName: String {
        var returnValue = ""
        switch self {
        case .sepia:
            returnValue = "Sepia"
        case .chrome:
            returnValue =  "Chrome"
        case .fade:
            returnValue =  "Fade"
        case .invert:
            returnValue =  "Invert"
        case .posterize:
            returnValue =  "Posterize"
        case .sketch:
            returnValue =  "Sketch"
        case .comic:
            returnValue =  "Comic"
        case .crystal:
            returnValue =  "Crystal"
        }
        return returnValue
    }
}
