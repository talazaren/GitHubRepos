//
//  GitHubRepoNetworkService.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import SwiftUI

protocol GitHubRepoNetworkService {
    func fetchRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [SearchReposRepository]
}


actor GitHubRepoNetworkServiceImpl: GitHubRepoNetworkService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }
    
    func fetchRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [SearchReposRepository] {
        do {
            let (responseData, _): (SearchReposAPIResponse, HTTPURLResponse) = try await networkService.fetch(from: ReposEndpoint(page: page, sort: sort, order: order))
            return responseData.items
        } catch NetworkError.httpError(let response) {
            throw validateFetchReposResponse(response)
        } catch {
            throw NetworkError.unknownError(0)
        }
    }
    
    private func validateFetchReposResponse(_ response: HTTPURLResponse) -> NetworkError {
        switch response.statusCode {
        case 400...499:
            let remainingLimit = response.allHeaderFields["x-ratelimit-remaining"]
            if let remainingLimit = remainingLimit as? String, Int(remainingLimit) == 0, response.statusCode == 403 {
                return NetworkError.rateLimitExceeded(response.statusCode)
            }
            return NetworkError.clientError(response.statusCode)
        case 500...599:
            return NetworkError.serverError(response.statusCode)
        default:
            return NetworkError.unknownError(response.statusCode)
        }
    }
}
