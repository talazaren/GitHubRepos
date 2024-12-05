//
//  Network.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI

protocol NetworkService {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> (T, HTTPURLResponse)
}

actor NetworkServiceImpl: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> (T, HTTPURLResponse) {
        let request = try endpoint.urlRequest()
        print("Request sent")
        let (data, response) = try await session.data(for: request)
        print("Reponse received")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateResponse(httpResponse)
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return (decodedData, httpResponse)
        } catch {
            print(error)
            throw NetworkError.decodingFailed
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        default:
            throw NetworkError.httpError(response)
        }
    }
}
