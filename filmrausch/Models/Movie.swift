//
//  Movies.swift
//  filmrausch
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import Foundation

struct Movie: Codable, Equatable {
    let name, date, year, length: String
    let genre, director, special: String
    let lang: Lang
    let intro, quote, description: String
    let trailerlink, infolink: String
    let poster: String
}

enum Lang: String, Codable {
    case deutsch = "Deutsch"
    case ov = "OV"
}
