//
//  DBError.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import Foundation

enum DBError: Error {
    case notFound
}

extension DBError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Not found"
        }
    }
}
