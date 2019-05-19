//
//  MockURLSessionDataTask.swift
//  filmrauschTests
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
