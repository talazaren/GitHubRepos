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
        VStack {
            if let error = reposService.error {
                Text(error.localizedDescription)
                    .font(.headline)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(reposService.repos, id: \.id) { repo in
                            RepoRowView(repo: repo)
                                .onAppear {
                                    Task {
                                        await reposService.loadMoreContent(repo)
                                    }
                                }
                        }
                    }
                }
                
                LoadingRowView()
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
