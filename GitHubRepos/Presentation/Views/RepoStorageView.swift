//
//  RepoStorageView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/3/24.
//

import SwiftUI
import SwiftData

struct RepoStorageView: View {
    @Environment(RepositoryViewModel.self) private var repoVM
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            List {
                ForEach(repoVM.repositories) { repository in
                    NavigationLink(value: repository) {
                        RepoRowView(repo: repository)
                            .onAppear {
                                Task {
                                    await repoVM.loadMoreRepos(repo: repository)
                                }
                            }
                        
                    }
                }
                .onDelete(perform: repoVM.deleteRepo)
            }
            .navigationDestination(for: GHRepository.self) { repo in
                RepoDetailView(repo: repo)
            }
            .listStyle(.plain)
            .onChange(of: repoVM.error) { _, _ in
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Oops"), message: Text(repoVM.error?.localizedDescription ?? "error"), dismissButton: .default(Text("OK")))
            }
            
            LoadingRowView()
            
        }
        .task {
            await repoVM.fetchRepos()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await repoVM.fetchRepos()
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await repoVM.deleteRepos()
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    RepoStorageView()
        .environment(RepositoryViewModel())
}
