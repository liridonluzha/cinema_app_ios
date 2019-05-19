//
//  filmrauschTests.swift
//  filmrauschTests
//
//  Created by Liridon Luzha on 16.12.18.
//  Copyright © 2018 Liridon Luzha. All rights reserved.
//

import XCTest
@testable import filmrausch

class filmrauschTests: XCTestCase {


    func testDateFormatter() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let movie_date = "2018-11-13T23:00:00.000Z"
        let movie_date_res = movie_date.toDate()
        print(movie_date_res)
        XCTAssertEqual(movie_date_res.asString(style: .short), "14.11.18")
    }
    
    
    
}
