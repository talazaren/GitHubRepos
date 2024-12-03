//
//  Network.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI

protocol NetworkManaging {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkManaging {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateResponse(httpResponse)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400...499:
            let remainingLimit = response.allHeaderFields["x-ratelimit-remaining"]
            if let remainingLimit = remainingLimit as? String, Int(remainingLimit) == 0, response.statusCode == 403 {
                throw NetworkError.rateLimitExceeded(response.statusCode)
            }
            throw NetworkError.clientError(response.statusCode)
        case 500...599:
            throw NetworkError.serverError(response.statusCode)
        default:
            throw NetworkError.unknownError(response.statusCode)
        }
    }
}
