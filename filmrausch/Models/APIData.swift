//
//  APIData.swift
//  filmrausch
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import Foundation

struct ApiData: Codable {
    let data: [Movie]
    let meta: Meta
}
