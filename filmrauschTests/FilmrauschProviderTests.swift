//
//  FilmrauschProviderTests.swift
//  filmrauschTests
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import XCTest
@testable import filmrausch

class FilmrauschProviderTests: XCTestCase {

    var session: MockURLSession!
    var sut: FilmrauschProvider!

    override func setUp() {
        session = MockURLSession()
        sut = FilmrauschProvider(session: session)
    }

    func testError() {
        let expectation = XCTestExpectation(description: "InvalidURL Error")
        session.error = MovieError.invalidUrl
        sut.getMovies(onSuccess: { _ in }, onError:  { error in
            if let error = error as? MovieError, error == .invalidUrl {
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 5)
    }

    func testSuccess() throws {
        let expectation = XCTestExpectation(description: "Should be parsed successfull")
        let movie = Movie(name: "a",
                           date: "b",
                           year: "c",
                           length: "d",
                           genre: "e",
                           director: "f",
                           special: "g",
                           lang: .deutsch,
                           intro: "i",
                           quote: "j",
                           description: "k",
                           trailerlink: "l",
                           infolink: "m",
                           poster: "n")
        let data = ApiData(data: [movie, movie], meta: Meta(semester: "a", hVs: "b"))
        session.data = try JSONEncoder().encode(data)
        sut.getMovies(onSuccess: { movies in
            if movie == movies.first, movie == movies.last {
                expectation.fulfill()
            }
        }, onError: { _ in })
        
        wait(for: [expectation], timeout: 2)
    }

}


