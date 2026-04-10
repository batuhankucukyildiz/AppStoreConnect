//
//  APIClient.swift
//  Connect
//
//  Created by Batuhan Küçükyıldız on 10.04.2026.
//

import Foundation

final class APIClient: APIClientProtocol {
    private let baseURL: String
    private let session: URLSession
    private let tokenProvider: TokenProvider

    init(
        baseURL: String,
        session: URLSession = .shared,
        tokenProvider: TokenProvider
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider
    }

    func send<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T {
        let request = try makeRequest(from: endpoint)
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func send(_ endpoint: Endpoint) async throws {
        let request = try makeRequest(from: endpoint)
        _ = try await session.data(for: request)
    }

    private func makeRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let token = try tokenProvider.fetchToken()

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
