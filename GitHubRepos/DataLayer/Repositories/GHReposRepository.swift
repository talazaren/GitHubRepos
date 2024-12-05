//
//  GHReposRepository.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import Foundation

protocol GHReposRepository {
    func getInitialRepos() async throws -> [GHRepository]
    func getMoreRepos(page: Int) async throws -> [GHRepository]
    func deleteRepos(repos: [GHRepository]) async throws
    func updateRepo(repo: GHRepository) async throws
}

final class GHReposRepositoryImpl: GHReposRepository {
    private let api: GitHubRepoNetworkService
    private let db: GitHubReposDBService?
    
    init(
        api: GitHubRepoNetworkService = GitHubRepoNetworkServiceImpl(),
        db: GitHubReposDBService? = try? GitHubReposDBServiceImpl()
    ) {
        self.api = api
        self.db = db
    }
    
    func getInitialRepos() async throws -> [GHRepository] {
        let DBRepos = try await db?.fetchRepos() ?? []
        
        if DBRepos.isEmpty {
            return try await fetchReposAndSaveToDB(page: 1)
        } else {
            return DBRepos
        }
    }
    
    func getMoreRepos(page: Int) async throws -> [GHRepository] {
        return try await fetchReposAndSaveToDB(page: page)
    }
    
    func deleteRepos(repos: [GHRepository]) async throws {
        try await db?.delete(repos: repos)
    }
    
    func updateRepo(repo: GHRepository) async throws {
        try await db?.update(repo: repo)
    }
    
    private func convertToGHRepos(_ repos: [SearchReposRepository]) -> [GHRepository] {
        repos.map { repo in
            GHRepository(
                id: String(repo.id),
                name: repo.name,
                repoDescription: repo.description ?? "No description",
                image: repo.owner.avatar_url ?? Constants.imagePlaceholder
            )
        }
    }
    
    private func fetchReposAndSaveToDB(page: Int) async throws -> [GHRepository] {
        let DBRepos = try await db?.fetchRepos() ?? []
        let repos = try await api.fetchRepos(page: page)
        let convertedRepos = convertToGHRepos(repos)
        
        let filteredRepos = convertedRepos.reduce([] as [GHRepository]) { dbRepos, repo in
            if !DBRepos.map(\.id).contains(repo.id) {
                return dbRepos + [repo]
            } else {
                return dbRepos
            }
        }
        
        try await db?.add(repos: filteredRepos)
        
        return filteredRepos
    }
}
