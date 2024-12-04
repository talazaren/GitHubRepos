//
//  RepoStorageView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/3/24.
//

import SwiftUI
import SwiftData

struct RepoStorageView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ReposService.self) private var reposService
    
    @State private var showAlert = false
    
    @Query private var reposStored: [RepoStore]
    
    var body: some View {
        VStack {
            List {
                ForEach(reposStored) { repoStore in
                    let convertedRepo = Repository(
                        id: Int(repoStore.id) ?? Int.random(in: 10000000...900000000),
                        name: repoStore.name,
                        description: repoStore.repoDescription,
                        owner: Owner(avatar_url: repoStore.image)
                    )
                    NavigationLink(value: repoStore) {
                        RepoRowView(repo: convertedRepo)
                            .onAppear {
                                Task {
                                    await reposService.loadMore(repoStore, reposStored, modelContext) {
                                        reposService.setPage(for: reposStored)
                                    }
                                }
                                
                            }
                    }
                }
                .onDelete(perform: deleteRepo)
            }
            .navigationDestination(for: RepoStore.self) { repo in
                RepoDetailView(repo: repo)
            }
            .listStyle(.plain)
            .onChange(of: reposService.error) { _, _ in
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Oops"), message: Text(reposService.error?.localizedDescription ?? "error"), dismissButton: .default(Text("OK")))
            }
            
            LoadingRowView()
        }
        .task {
            await reposService.fetchRepos(modelContext: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await reposService.fetchRepos(modelContext: modelContext)
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    reposService.deleteRepositories(from: modelContext, repos: reposStored)
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    private func deleteRepo(at offsets: IndexSet) {
        offsets.forEach { index in
            let repo = reposStored[index]
            modelContext.delete(repo)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Saving context error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RepoStorageView()
        .environment(ReposService())
}
