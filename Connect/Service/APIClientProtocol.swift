//
//  APIClientProtocol.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import Foundation

protocol APIClientProtocol {
    func send<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T
    func send(_ endpoint: Endpoint) async throws
}
