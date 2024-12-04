//
//  ContentView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var repoVM = RepositoryViewModel()
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            GHRepository.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some View {
        NavigationStack {
            RepoStorageView()
        }
        .environment(repoVM)
        //.modelContainer(sharedModelContainer)
    }
}

#Preview {
    ContentView()
}
