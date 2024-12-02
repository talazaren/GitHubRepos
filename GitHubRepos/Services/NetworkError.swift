//
//  NetworkError.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI

enum NetworkError: Error {
    case invalidResponse
    case decodingFailed
    case clientError(Int)
    case serverError(Int)
    case unknownError(Int)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response received from the server."
        case .decodingFailed:
            return "Failed to decode the response data."
        case .clientError(let statusCode):
            return "Client error occurred. Status code: \(statusCode)"
        case .serverError(let statusCode):
            return "Server error occurred. Status code: \(statusCode)"
        case .unknownError(let statusCode):
            return "An unknown error occurred. Status code: \(statusCode)"
        }
    }
}
