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
            TextField("Input image link", text: $imageLink)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .foregroundStyle(.gray)
            
            TextField("Input repository name", text: $title)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .font(.title)
            
            TextField("Input repository description", text: $description)
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
                    repo.image = imageLink
                    repo.name = title
                    repo.repoDescription = description
                    
                    /*do {
                        try modelContext.save()
                    } catch {
                        print("Saving context error: \(error.localizedDescription)")
                    }*/
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RepoDetailView(repo: GHRepository(name: "Repository", repoDescription: "Description", image: "https://ru.meming.world/images/ru/7/73/%D0%A8%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD_%D0%BA%D0%BE%D1%82.jpg"))
        .environment(RepositoryViewModel())
}
