//
//  PhotoFilterTests.swift
//  PhotoFilterTests
//
//  Created by Sheen on 10/27/24.
//

import XCTest
@testable import PhotoFilter

final class PhotoFilterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApplyFilter() async throws {
        let filterManager = FilterManager()
        guard let image = UIImage(systemName: "multiply.circle.fill"),
                let ciImage =  CIImage(image: image) else {
            XCTFail()
            return
        }
        let _ = try await filterManager.applyFilter(image: ciImage, filter: .chrome)
    }
    
    func testGenerateThumbnail() async throws {
        let filterThumbnailHandler = FilterThumbnailHandler()
        guard let image = UIImage(systemName: "multiply.circle.fill"),
                let ciImage =  CIImage(image: image) else {
            XCTFail()
            return
        }
        let thumbnails = try await filterThumbnailHandler.generateThumbnails(Filter.allCases, ciImage)
        XCTAssertEqual(thumbnails.count, Filter.allCases.count)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
