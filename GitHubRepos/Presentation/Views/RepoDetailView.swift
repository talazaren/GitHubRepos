//
//  RepoDetailView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/3/24.
//

import SwiftUI
import SwiftData

struct RepoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(RepositoryViewModel.self) private var repoVM
    
    var repo: GHRepository
    
    @State private var imageLink: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    
    init(repo: GHRepository) {
        self.repo = repo
        _imageLink = State(initialValue: repo.image)
        _title = State(initialValue: repo.name)
        _description = State(initialValue: repo.repoDescription)
    }
    
    var body: some View {
        VStack {
            if let url = URL(string: repo.image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .scaledToFit()
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
                        .padding(.horizontal, 8)
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }
            TextField(Constants.inputRepoLink, text: $imageLink)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .foregroundStyle(.gray)
            
            TextField(Constants.inputRepoTitle, text: $title)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .font(.title)
            
            TextField(Constants.inputRepoDesc, text: $description)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .font(.title3)
                .foregroundStyle(.gray)
            
            Spacer()
                
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        await repoVM.updateRepo(
                            repo: GHRepository(
                                id: repo.id,
                                name: title,
                                repoDescription: description,
                                image: imageLink,
                                stars: repo.stars,
                                updatedAt: Date()
                            )
                        )
                    }
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RepoDetailView(repo: GHRepository(name: "Repository", repoDescription: "Description", image: Constants.imagePlaceholder, stars: 100, updatedAt: Date()))
        .environment(RepositoryViewModel())
}
