//
//  RepoRowView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct RepoRowView: View {
    var repo: GHRepository
    
    var body: some View {
        HStack(alignment: .top) {
            if let url = URL(string: repo.image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(width: 40, height: 40)
                        .padding(.horizontal, 8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .padding(.horizontal, 8)
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.horizontal, 8)
            }
            
            VStack(alignment: .leading) {
                Text("\(repo.stars)")
                    .font(.headline)
                Text("\(repo.pushedAt)")
                    .foregroundStyle(.gray)
                    .lineLimit(5)
            }
            .padding(.top, -4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    RepoRowView(repo: GHRepository(id: "111", name: "Repo", repoDescription: "Description", image: Constants.imagePlaceholder, stars: 100, updatedAt: Date()))
}
