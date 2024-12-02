//
//  RepositoriesView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct RepositoriesView: View {
    @State private var viewModel = ReposViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                } else {
                    List(viewModel.repos) { repo in
                        HStack {
                            Text(repo.name)
                        }
                    }
                }
            }
            .navigationTitle("Repositories")
        }
        .task {
            await viewModel.fetchRepos()
        }
    }
}

#Preview {
    RepositoriesView()
}
