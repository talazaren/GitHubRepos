//
//  RepoRowView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct RepoRowView: View {
    var repo: Repository
    
    var body: some View {
        HStack(alignment: .top) {
            if let url = URL(string: repo.owner.avatar_url ?? "https://ru.meming.world/images/ru/7/73/%D0%A8%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD_%D0%BA%D0%BE%D1%82.jpg") {
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
                Text(repo.name)
                    .font(.headline)
                Text(repo.description ?? "No description")
                    .foregroundStyle(.gray)
            }
            .padding(.top, -4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    RepoRowView(repo: Repository(id: 111, name: "Repo", description: "Description", owner: Owner(avatar_url: "https://ru.meming.world/images/ru/7/73/%D0%A8%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD_%D0%BA%D0%BE%D1%82.jpg")))
}
