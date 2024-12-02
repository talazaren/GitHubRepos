//
//  NetworkViewModel.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

@Observable
final class ReposViewModel {
    var repos: [Repository] = []
    var error: NetworkError?
    
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchRepos() async {
        do {
            let response: APIResponse = try await networkManager.fetch(from: ReposEndpoint())
            self.repos = response.items
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknownError(0)
        }
    }
}

