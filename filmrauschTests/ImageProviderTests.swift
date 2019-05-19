//
//  ImageProviderTests.swift
//  filmrauschTests
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import XCTest
@testable import filmrausch

class ImageProviderTests: XCTestCase {

    var sut: ImageProvider!

    override func setUp() {
        sut = ImageProvider()
    }

    func testGet() {
        let expectation = XCTestExpectation(description: "Load Image")
        let url = Bundle(for: type(of: self)).url(forResource: "test", withExtension: "png")!
        let data = try! Data(contentsOf: url)
        let expected = UIImage(data: data)

        sut.getFrom(urlString: url.absoluteString) { image in
            if image?.pngData() == expected?.pngData() {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
