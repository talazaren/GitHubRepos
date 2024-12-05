//
//  GHRepoNetworkServiceImplTests.swift
//  GitHubReposTests
//
//  Created by Tatiana Lazarenko on 12/5/24.
//

import XCTest
@testable import GitHubRepos

final class GHRepoNetworkServiceImplTests: XCTestCase {
    var networkService: MockNetworkService!
    var repoService: GitHubRepoNetworkServiceImpl!
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        repoService = GitHubRepoNetworkServiceImpl(networkService: networkService)
    }
    
    override func tearDown() {
        networkService = nil
        repoService = nil
        super.tearDown()
    }
    
    func testFetchRepos_success() async throws {
        let mockResponse = SearchReposAPIResponse(items: [
            SearchReposRepository(id: 1, name: "Repo1", description: "Description1", owner: .init(avatar_url: "URL1"), stargazers_count: 10, pushed_at: "2024-12-01T00:00:00Z"),
            SearchReposRepository(id: 2, name: "Repo2", description: "Description2", owner: .init(avatar_url: "URL2"), stargazers_count: 20, pushed_at: "2024-12-02T00:00:00Z")
        ])
        networkService.mockResponse = (mockResponse, HTTPURLResponse())
        
        let repos = try await repoService.fetchRepos(page: 1, sort: .stars, order: .asc)
        
        XCTAssertEqual(repos.count, 2)
        XCTAssertEqual(repos[0].id, 1)
        XCTAssertTrue(networkService.fetchCalled)
    }
    
    func testFetchRepos_rateLimitExceeded() async {
        let httpResponse = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                           statusCode: 403,
                                           httpVersion: nil,
                                           headerFields: ["x-ratelimit-remaining": "0"])!
        networkService.mockError = NetworkError.httpError(httpResponse)
        
        do {
            let _ = try await repoService.fetchRepos(page: 1, sort: .stars, order: .asc)
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.rateLimitExceeded(403))
        }
    }
    
    func testFetchRepos_serverError() async {
        let httpResponse = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
        networkService.mockError = NetworkError.httpError(httpResponse)
        
        do {
            let _ = try await repoService.fetchRepos(page: 1, sort: .stars, order: .asc)
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.serverError(500))
        }
    }
    
    func testFetchRepos_unknownError() async {
        networkService.mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        do {
            let _ = try await repoService.fetchRepos(page: 1, sort: .stars, order: .asc)
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.unknownError(0))
        }
    }
}
