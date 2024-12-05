//
//  GHReposRepository.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import Foundation

protocol GHReposRepository {
    func getInitialRepos(sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository]
    func getMoreRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository]
    func deleteRepos(repos: [GHRepository]) async throws
    func updateRepo(repo: GHRepository) async throws
}

actor GHReposRepositoryImpl: GHReposRepository {
    private let api: GitHubRepoNetworkService
    private let db: GitHubReposDBService?
    
    init(
        api: GitHubRepoNetworkService = GitHubRepoNetworkServiceImpl(),
        db: GitHubReposDBService? = try? GitHubReposDBServiceImpl()
    ) {
        self.api = api
        self.db = db
    }
    
    func getInitialRepos(sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository] {
        let DBRepos = try await getSortedReposFromDB(sort: sort, order: order)
        
        if DBRepos.isEmpty {
            return try await fetchReposAndSaveToDB(page: 1, sort: sort, order: order)
        } else {
            return DBRepos
        }
    }
    
    func getMoreRepos(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository] {
        return try await fetchReposAndSaveToDB(page: page, sort: sort, order: order)
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
                image: repo.owner.avatar_url ?? Constants.imagePlaceholder,
                stars: repo.stargazers_count,
                updatedAt: repo.pushed_at?.toDate() ?? Date()
            )
        }
    }
    
    private func fetchReposAndSaveToDB(page: Int, sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository] {
        let DBRepos = try await getSortedReposFromDB(sort: sort, order: order)
        let repos = try await api.fetchRepos(page: page, sort: sort, order: order)
        let filteredRepos = repos.reduce([] as [SearchReposRepository]) { dbRepos, repo in
            if repo.pushed_at == nil {
                return dbRepos
            } else if !DBRepos.map(\.id).contains(String(repo.id)) {
                return dbRepos + [repo]
            } else {
                return dbRepos
            }
        }
        let convertedRepos = convertToGHRepos(filteredRepos)
        
        try await db?.add(repos: convertedRepos)
        
        return convertedRepos
    }
    
    private func getSortedReposFromDB(sort: SearchReposSort, order: SearchReposOrder) async throws -> [GHRepository] {
        if let DBRepos = try await db?.fetchRepos() {
            return DBRepos.sorted {
                switch sort {
                case .stars:
                    return order == .asc ? $0.stars < $1.stars : $0.stars > $1.stars
                case .updated:
                    return order == .asc ? $0.pushedAt < $1.pushedAt : $0.pushedAt > $1.pushedAt
                }
            }
        }
        return []
    }
}
