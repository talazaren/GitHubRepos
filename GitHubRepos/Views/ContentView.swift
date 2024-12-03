//
//  ContentView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var reposService = ReposService()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RepoStore.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some View {
        NavigationStack {
            RepoStorageView()
        }
        .environment(reposService)
        .modelContainer(sharedModelContainer)
    }
}

#Preview {
    ContentView()
}
