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

    var body: some View {
        RepoStorageView()
            .environment(repoVM)
    }
}

#Preview {
    ContentView()
}
