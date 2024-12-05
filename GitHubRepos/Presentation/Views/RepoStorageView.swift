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
    @State private var sort: SearchReposSort = .stars
    
    var body: some View {
        NavigationStack {
            VStack {
                SortView(sort: $sort)
                
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
                .listStyle(.plain)
                .navigationDestination(for: GHRepository.self) { repo in
                    RepoDetailView(repo: repo)
                }
                .onChange(of: repoVM.error) { _, _ in
                    showAlert = true
                }
                .alert(Constants.alertTitle, isPresented: $showAlert) {
                    Button(role: .cancel) {
                    } label: {
                        Text("OK")
                    }
                } message: {
                    Text(repoVM.error?.localizedDescription ?? "Error")
                }
                
                LoadingRowView()
                
            }
            .onAppear {
                sort = repoVM.sort
            }
            .onChange(of: sort) { _, sort in
                repoVM.sort = sort
            }
            .navigationTitle(Constants.viewTitle)
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
}

#Preview {
    RepoStorageView()
        .environment(RepositoryViewModel())
}
