//
//  TicketService.swift
//  filmrausch
//
//  Created by Philipp Wallrich on 28.01.19.
//  Copyright © 2019 Liridon Luzha. All rights reserved.
//

import Foundation

protocol TicketFetchable {
    func get(for date: String, onSuccess: @escaping (Ticket) -> Void, onError: @escaping (Error) -> Void)
}

enum TicketError: Error {
    case invalidUrl
    case invalidData
}

class TicketService: TicketFetchable {

    private let session: URLSession
    private let urlString = "https://us-central1-filmrausch-df4df.cloudfunctions.net/getTicket"
    private let decoder: JSONDecoder

    init(session: URLSession) {
        self.session = session
        decoder = JSONDecoder()
    }
    
    func get(for date: String, onSuccess: @escaping (Ticket) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: "\(urlString)?id=\(date)") else {
            onError(TicketError.invalidUrl)
            return
        }
        session.dataTask(with: url)  { (data, response, err) in
            if let err = err {
                onError(err)
                print("Failed to get data from url:", err)
                return
            }

            guard let ticket = self.handleResponse(data: data) else {
                onError(TicketError.invalidData)
                return
            }
            onSuccess(ticket)
        }.resume()
    }

    private func handleResponse(data: Data?) -> Ticket? {
        guard let data = data else {
            return nil
        }
        guard let ticket = try? self.decoder.decode(Ticket.self, from: data) else {
                return nil
        }
        return ticket
    }

    
}

extension TicketService {
    convenience init() {
        self.init(session: URLSession.shared)
    }
}
