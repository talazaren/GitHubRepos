//
//  RepositoriesView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct RepositoriesView: View {
    @Environment(ReposService.self) private var reposService
    
    var body: some View {
        NavigationStack {
            if let error = reposService.error {
                Text(error.localizedDescription)
            } else {
                List {
                    ForEach(reposService.repos, id: \.id) { repo in
                        //Text(repo.name)
                        RepoRowView(repo: repo)
                            .task {
                                await reposService.loadMoreContent(repo)
                            }
                    }
                    
                    LoadingRowView()
                }
                .listStyle(.plain)
            }
            
            
        }
        .navigationTitle("Repositories")
        .task {
            await reposService.fetchRepos()
        }
    }
}

#Preview {
    RepositoriesView()
        .environment(ReposService())
}
