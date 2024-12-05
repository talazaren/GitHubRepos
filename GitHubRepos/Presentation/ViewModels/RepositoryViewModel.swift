//
//  RepositoryViewModel.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/4/24.
//

import SwiftUI

@Observable
final class RepositoryViewModel {
    var repositories: [GHRepository] = []
    var error: NetworkError? {
        didSet {
            loadingStatus = .notLoading
        }
    }
    var loadingStatus: LoadingStatus = .notLoading
    var sort: SearchReposSort = getInitialSort() {
        didSet {
            Task {
                print(sort.rawValue)
                await UserDefaults.standard.set(sort.rawValue, forKey: Constants.udSearchReposSortsKey)
                print(UserDefaults.standard.string(forKey: Constants.udSearchReposSortsKey))
                await deleteRepos()
                await fetchRepos()
            }
        }
    }
    var order: SearchReposOrder = getInitialOrder() {
        didSet {
            Task {
                UserDefaults.standard.set(order.rawValue, forKey: Constants.udSearchReposOrderKey)
                await deleteRepos()
                await fetchRepos()
            }
        }
    }
    
    private let useCase: GHRepositoriesUseCase
    
    init(useCase: GHRepositoriesUseCase = GHRepositoriesUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func fetchRepos() async {
        do {
            error = nil
            loadingStatus = .loading
            repositories = try await useCase.getInitialRepos(sort: sort, order: order)
            loadingStatus = .notLoading
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknownError(0)
        }
    }
    
    func loadMoreRepos(repo: GHRepository) async {
        if loadingStatus == .loading {
            return
        }
        if repositories.isLast(repo) {
            do {
                error = nil
                loadingStatus = .loading
                let page = Int((Double(repositories.count) / Double(Constants.perPage)).rounded(.up)) + 1
                let newRepos = try await useCase.getMoreRepos(page: page, sort: sort, order: order)
                repositories += newRepos
                loadingStatus = .notLoading
            } catch let error as NetworkError {
                self.error = error
            } catch {
                self.error = .unknownError(0)
            }
        }
    }
    
    func deleteRepos() async {
        do {
            try await useCase.deleteRepos(repos: repositories)
            repositories.removeAll()
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
    
    func deleteRepo(offsets: IndexSet) {
        offsets.forEach { index in
            let repo = repositories[index]
            Task {
                do {
                    try await useCase.deleteRepos(repos: [repo])
                    repositories.remove(at: index)
                } catch {
                    print("Saving context error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateRepo(repo: GHRepository) async {
        do {
            try await useCase.updateRepo(repo: repo)
            guard let index = repositories.map(\.id).firstIndex(of: repo.id) else { return }
            repositories[index] = repo
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
    
    private static func getInitialSort() -> SearchReposSort {
        let sort = UserDefaults.standard.string(forKey: Constants.udSearchReposSortsKey) ?? SearchReposSort.stars.rawValue
        return SearchReposSort(rawValue: sort) ?? .stars
    }
    
    private static func getInitialOrder() -> SearchReposOrder {
        let order = UserDefaults.standard.string(forKey: Constants.udSearchReposOrderKey) ?? SearchReposOrder.asc.rawValue
        return SearchReposOrder(rawValue: order) ?? .asc
    }
}
