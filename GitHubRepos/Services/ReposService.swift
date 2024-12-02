//
//  NetworkViewModel.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

@Observable
final class ReposService {
    var repos: [Repository] = []
    var error: NetworkError?
    var page: Int = 1
    var loadingStatus: LoadingStatus = .notLoading
    
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchRepos() async {
        do {
            loadingStatus = .loading
            let response: APIResponse = try await networkManager.fetch(from: ReposEndpoint(page: page))
            self.repos.append(contentsOf: response.items)
            loadingStatus = .notLoading
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknownError(0)
        }
    }
    
    func loadMoreContent(_ repo: Repository) async {
        if repos.isLast(repo) {
            page += 1
            await fetchRepos()
        }
    }
}

enum LoadingStatus: String {
    case loading = "Loading..."
    case notLoading = "Not Loading..."
}
