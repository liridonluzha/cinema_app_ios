//
//  FilmrauschFetcher.swift
//  filmrausch
//
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import Foundation


protocol MovieFetchable {
    func getMovies(onSuccess: @escaping ([Movie]) -> (), onError:  @escaping (Error) -> ())
}

enum MovieError: Error {
    case invalidUrl
}

class FilmrauschProvider: MovieFetchable {
    
    private let urlString = "http://filmrausch.hdm-stuttgart.de/api"
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession) {
        self.session = session
        decoder = JSONDecoder()
    }
    
    func getMovies(onSuccess: @escaping ([Movie]) -> (), onError: @escaping (Error) -> ()) {
        guard let url = URL(string: urlString) else {
            onError(MovieError.invalidUrl)
            return
        }
        session.dataTask(with: url) { (data, _, err) in
            if let err = err {
                onError(err)
                print("Failed to get data from url:", err)
                return
            }
            do {
                let movies = try self.parseDataToMovies(data: data)
                onSuccess(movies)
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
                onError(jsonErr)
            }
            
            }.resume()
    }
    
    private func parseDataToMovies(data: Data?) throws -> [Movie]  {
        guard let data = data else {
            return []
        }
        let apidata = try decoder.decode(ApiData.self, from: data)
        return apidata.data
    }
}

extension FilmrauschProvider {
    convenience init() {
        self.init(session: URLSession.shared)
    }
}

