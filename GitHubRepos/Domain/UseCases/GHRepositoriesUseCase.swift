//
//  GHRepositoriesUseCase.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import Foundation

protocol GHRepositoriesUseCase {
    func getInitialRepos() async throws -> [GHRepository]
    func getMoreRepos(page: Int) async throws -> [GHRepository]
    func deleteRepos(repos: [GHRepository]) async throws
}

final class GHRepositoriesUseCaseImpl: GHRepositoriesUseCase {
    private let repository: GHReposRepository
    
    init(repository: GHReposRepository = GHReposRepositoryImpl()) {
        self.repository = repository
    }
    
    func getMoreRepos(page: Int) async throws -> [GHRepository] {
        try await repository.getMoreRepos(page: page)
    }
    
    func getInitialRepos() async throws -> [GHRepository] {
        try await repository.getInitialRepos()
    }
    
    func deleteRepos(repos: [GHRepository]) async throws {
        try await repository.deleteRepos(repos: repos)
    }
}
