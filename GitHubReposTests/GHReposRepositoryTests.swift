//
//  GitHubReposTests.swift
//  GitHubReposTests
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import XCTest
@testable import GitHubRepos

final class GHReposRepositoryTests: XCTestCase {
    var repository: GHReposRepositoryImpl!
    var mockApi: MockGitHubRepoNetworkService!
    var mockDb: MockGitHubReposDBService!
    
    override func setUp() {
        super.setUp()
        mockApi = MockGitHubRepoNetworkService()
        mockDb = MockGitHubReposDBService()
        repository = GHReposRepositoryImpl(api: mockApi, db: mockDb)
    }
    
    override func tearDown() {
        mockApi = nil
        mockDb = nil
        repository = nil
        super.tearDown()
    }
    
    // MARK: - getInitialRepos Tests
    func testGetInitialRepos_sortsReposByStars() async throws {
        let unsortedRepos = [
            GHRepository(id: "1", name: "Repo1", repoDescription: "Desc", image: "URL", stars: 5, updatedAt: Date()),
            GHRepository(id: "2", name: "Repo2", repoDescription: "Desc", image: "URL", stars: 10, updatedAt: Date()),
            GHRepository(id: "3", name: "Repo3", repoDescription: "Desc", image: "URL", stars: 7, updatedAt: Date())
        ]
        mockDb.fetchReposReturnValue = unsortedRepos
        
        // Act
        let result = try await repository.getInitialRepos(sort: .stars, order: .asc)
        
        // Assert
        XCTAssertTrue(mockDb.fetchReposCalled)
        XCTAssertEqual(result.map(\.id), ["1", "3", "2"])
    }

    func testGetInitialRepos_sortsReposByUpdatedTime() async throws {
        let unsortedRepos = [
            GHRepository(id: "1", name: "Repo1", repoDescription: "Desc", image: "URL", stars: 5, updatedAt: Date().addingTimeInterval(-3600)),
            GHRepository(id: "2", name: "Repo2", repoDescription: "Desc", image: "URL", stars: 10, updatedAt: Date())
        ]
        mockDb.fetchReposReturnValue = unsortedRepos
        
        // Act
        let result = try await repository.getInitialRepos(sort: .updated, order: .desc)
        
        // Assert
        XCTAssertTrue(mockDb.fetchReposCalled)
        XCTAssertEqual(result.map(\.id), ["2", "1"])
    }
    
    func testGetInitialRepos_ifEmptyDB_takesAPIData() async throws {
        mockDb.fetchReposReturnValue = []
        let apiRepos = [
            SearchReposRepository(id: 1, name: "Repo1", description: "Desc", owner: .init(avatar_url: "URL"), stargazers_count: 100, pushed_at: "2024-12-01T00:00:00Z")
        ]
        mockApi.fetchReposReturnValue = apiRepos
        
        // Act
        let result = try await repository.getInitialRepos(sort: .stars, order: .desc)
        
        // Assert
        XCTAssertTrue(mockDb.fetchReposCalled)
        XCTAssertTrue(mockApi.fetchReposCalled)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(mockDb.addedRepos.count, 1)
    }
    
    // MARK: - getMoreRepos Tests
    func testGetMoreRepos_callsMoreAPIData_addToDB() async throws {
        mockDb.fetchReposReturnValue = []
        let apiRepos = [
            SearchReposRepository(id: 1, name: "Repo1", description: "Desc", owner: .init(avatar_url: "URL"), stargazers_count: 100, pushed_at: "2024-12-01T00:00:00Z")
        ]
        mockApi.fetchReposReturnValue = apiRepos
        
        // Act
        let result = try await repository.getMoreRepos(page: 1, sort: .stars, order: .asc)
        
        // Assert
        XCTAssertTrue(mockApi.fetchReposCalled)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(mockDb.addedRepos.count, 1) // Ensures repos are saved to DB
    }
}
