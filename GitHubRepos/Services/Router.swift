//
//  Router.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/3/24.
//

import SwiftUI

enum TabRoute: Hashable {
    case network
    case storage
}

enum Route: Hashable {
    case main
    case details
}

@Observable
final class Router {
    var startScreen: Route = .main
    var path = NavigationPath()
    
    @ViewBuilder func tabView() -> some View {
        TabView {
            RepositoriesView()
                .tabItem {
                    Label("Network", systemImage: "globe")
                }
            
            RepoStorageView()
                .tabItem {
                    Label("Storage", systemImage: "shippingbox")
                }
        }
    }
        
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .main:
            tabView()
        case .details:
            RepositoriesView()
        }
    }
    
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
        
    func navigateBack() {
        path.removeLast()
    }
        
    func popToRoot() {
        path.removeLast(path.count)
    }
}

