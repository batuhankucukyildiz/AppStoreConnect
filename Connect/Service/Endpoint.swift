//
//  Endpoint 2.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
    var headers: [String: String] { get }
}
