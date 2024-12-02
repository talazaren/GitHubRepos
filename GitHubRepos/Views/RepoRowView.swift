//
//  RepoRowView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct RepoRowView: View {
    var repo: Repository?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repo?.name ?? "No name")
                .font(.headline)
            Text(repo?.description ?? "No description")
        }
    }
}

#Preview {
    RepoRowView(repo: Repository(id: 111, full_name: "11234/yjhtfg", name: "Repo", description: "Description", owner: Owner(avatar_url: "111")))
}
