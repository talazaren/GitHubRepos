//
//  GitHubRepoDBService.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import SwiftUI
import SwiftData

protocol GitHubReposDBService {
    func fetchRepos() async throws -> [GHRepository]
    func add(repos: [GHRepository]) async throws
    func delete(repos: [GHRepository]) async throws
}

final class GitHubReposDBServiceImpl: GitHubReposDBService {
    
    private let container: ModelContainer
    
    init() throws {
        container = try ModelContainer(for: GHRepository.self)
    }
    
    @MainActor
    func fetchRepos() async throws -> [GHRepository] {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<GHRepository>()
        return try context.fetch(fetchDescriptor)
    }
    
    @MainActor
    func add(repos: [GHRepository]) throws {
        let context = container.mainContext
        repos
            .forEach {
                context.insert($0)
            }
        try context.save()
    }
    
    @MainActor
    func delete(repos: [GHRepository]) throws {
        let context = container.mainContext
        repos
            .forEach {
                context.delete($0)
            }
        try context.save()
    }
}