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
/*
@MainActor
@Observable
final class ReposService {
    var error: NetworkError? {
        didSet {
            loadingStatus = .notLoading
        }
    }
    var page: Int = 1
    var perPage: Int = 10
    var loadingStatus: LoadingStatus = .notLoading
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImpl.shared) {
        self.networkService = networkService
    }
    
    func fetchRepos(modelContext: ModelContext) async {
        do {
            loadingStatus = .loading
            let response: SearchReposAPIResponse = try await networkService.fetch(from: ReposEndpoint(page: page, perPage: perPage))
            
            await saveToDatabase(modelContext: modelContext, items: response.items)
            loadingStatus = .notLoading
            
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknownError(0)
        }
    }
    
    func loadMore(_ repo: GHRepository, _ repos: [GHRepository], _ modelContext: ModelContext, completion: () -> Void) async {
        if loadingStatus == .loading {
            return
        }
        if repos.isLast(repo) {
            completion()
            await fetchRepos(modelContext: modelContext)
        }
    }
    
    func saveToDatabase(modelContext: ModelContext, items: [SearchReposRepository]) async {
        items.forEach { repo in
            let itemToStore = GHRepository(
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
    
    func deleteRepositories(from modelContext: ModelContext, repos: [GHRepository]) {
        repos.forEach { repo in
            modelContext.delete(repo)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
    
    func deleteRepo(at offsets: IndexSet, in repos: [GHRepository], modelContext: ModelContext) {
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
    
    func setPage(for repos: [GHRepository]) {
        page = repos.count / perPage
    }
}*/


