//
//  MockData.swift
//  GitHubReposTests
//
//  Created by Tatiana Lazarenko on 12/5/24.
//

import XCTest
@testable import GitHubRepos

final class MockGitHubRepoNetworkService: GitHubRepoNetworkService {
    var fetchReposCalled = false
    var fetchReposReturnValue: [SearchReposRepository] = []
    var fetchReposError: Error?
    
    func fetchRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [SearchReposRepository] {
        fetchReposCalled = true
        if let error = fetchReposError {
            throw error
        }
        return fetchReposReturnValue
    }
}

final class MockGitHubReposDBService: GitHubReposDBService {
    var fetchReposCalled = false
    var fetchReposReturnValue: [GHRepository] = []
    var fetchReposError: Error?
    
    var addCalled = false
    var addedRepos: [GHRepository] = []
    
    func fetchRepos() async throws -> [GHRepository] {
        fetchReposCalled = true
        if let error = fetchReposError {
            throw error
        }
        return fetchReposReturnValue
    }
    
    func add(repos: [GHRepository]) async throws {
        addCalled = true
        addedRepos = repos
    }
    
    func delete(repos: [GitHubRepos.GHRepository]) async throws {
        
    }
    
    func update(repo: GitHubRepos.GHRepository) async throws {
        
    }
}

final class MockNetworkService: NetworkService {
    var fetchCalled = false
    var mockResponse: (SearchReposAPIResponse, HTTPURLResponse)?
    var mockError: Error?

    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> (T, HTTPURLResponse) {
        fetchCalled = true
        if let error = mockError {
            throw error
        }
        if let response = mockResponse as? (T, HTTPURLResponse) {
            return response
        }
        throw NSError(domain: "MockNetworkServiceError", code: -1, userInfo: nil)
    }
}
