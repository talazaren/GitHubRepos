//
//  GHRepositoriesUseCase.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import Foundation

protocol GHRepositoriesUseCase {
    func getInitialRepos(sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository]
    func getMoreRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository]
    func deleteRepos(repos: [GHRepository]) async throws
    func updateRepo(repo: GHRepository) async throws
}

actor GHRepositoriesUseCaseImpl: GHRepositoriesUseCase {
    private let repository: GHReposRepository
    
    init(repository: GHReposRepository = GHReposRepositoryImpl()) {
        self.repository = repository
    }
    
    func getMoreRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository] {
        try await repository.getMoreRepos(page: page, sort: sort, order: order)
    }
    
    func getInitialRepos(sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository] {
        try await repository.getInitialRepos(sort: sort, order: order)
    }
    
    func deleteRepos(repos: [GHRepository]) async throws {
        try await repository.deleteRepos(repos: repos)
    }
    
    func updateRepo(repo: GHRepository) async throws {
        try await repository.updateRepo(repo: repo)
    }
}
