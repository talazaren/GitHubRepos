//
//  ContentView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var reposService = ReposService()
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            router.view(for: router.startScreen)
                .navigationDestination(for: Route.self) { view in
                    router.view(for: view)
                }
        }
        .environment(reposService)
        .environment(router)
    }

}

#Preview {
    ContentView()
}
