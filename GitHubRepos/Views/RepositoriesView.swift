//
//  RepositoriesView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct RepositoriesView: View {
    @State private var reposService = ReposService()
    
    var body: some View {
        NavigationStack {
            Group {
                if let error = reposService.error {
                    Text(error.localizedDescription)
                } else {
                    List {
                        ForEach(reposService.repos, id: \.id) { repo in
                            //RepoRowView(repo: repo)
                            Text(repo.name)
                                .task {
                                    await reposService.loadMoreContent(repo)
                                }
                        }
                        //.onDelete(perform: deleteRepos)
                    
                        switch reposService.loadingStatus {
                        case .loading:
                            Text(reposService.loadingStatus.rawValue)
                            //ProgressView()
                                //.frame(maxWidth: .infinity)
                        case .notLoading:
                            Text(reposService.loadingStatus.rawValue)
                            //EmptyView()
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Repositories")
        }
        .task {
            await reposService.fetchRepos()
        }
    }
}

#Preview {
    RepositoriesView()
        //.modelContainer(for: RepoStore.self, inMemory: true)
}
