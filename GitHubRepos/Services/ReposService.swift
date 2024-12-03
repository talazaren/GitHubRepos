//
//  NetworkViewModel.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI
import SwiftData

enum LoadingStatus: String {
    case loading = "Loading..."
    case notLoading = "Not Loading..."
}

@MainActor
@Observable
final class ReposService {
    var error: NetworkError?
    var page: Int = 1
    var loadingStatus: LoadingStatus = .notLoading
    
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchRepos(modelContext: ModelContext) async {
        do {
            loadingStatus = .loading
            let response: APIResponse = try await networkManager.fetch(from: ReposEndpoint(page: page))
            
            await saveToDatabase(modelContext: modelContext, items: response.items)
            loadingStatus = .notLoading
            
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknownError(0)
        }
    }
    
    func loadMore(_ repo: RepoStore, _ repos: [RepoStore], _ modelContext: ModelContext) async {
        if loadingStatus == .loading {
            return
        }
        if repos.isLast(repo) {
            page += 1
            await fetchRepos(modelContext: modelContext)
        }
    }
    
    func saveToDatabase(modelContext: ModelContext, items: [Repository]) async {
        items.forEach { repo in
            let itemToStore = RepoStore(
                name: repo.name,
                repoDescription: repo.description ?? "No description",
                image: repo.owner.avatar_url ?? "https://ru.meming.world/images/ru/7/73/%D0%A8%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD_%D0%BA%D0%BE%D1%82.jpg"
            )
            modelContext.insert(itemToStore)
        }
        do {
            try modelContext.save()
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
    
    func deleteRepositories(from modelContext: ModelContext, repos: [RepoStore]) {
        repos.forEach { repo in
            modelContext.delete(repo)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
    
    func deleteRepo(at offsets: IndexSet, in repos: [RepoStore], modelContext: ModelContext) {
        offsets.forEach { index in
            let repo = repos[index]
            modelContext.delete(repo)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
    
}


