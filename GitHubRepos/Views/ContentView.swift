//
//  ContentView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var reposService = ReposService()
    
    var body: some View {
        RepositoriesView()
            .environment(reposService)
    }

}

#Preview {
    ContentView()
}
