//
//  StorageService.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI
import SwiftData

final class StorageService {
    @Environment(\.modelContext) private var modelContext
    @Query private var reposStored: [RepoStore]

    private func deleteRepos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(reposStored[index])
            }
        }
    }
}
