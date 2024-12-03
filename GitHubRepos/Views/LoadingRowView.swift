//
//  LoadingRowView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct LoadingRowView: View {
    @Environment(ReposService.self) private var reposService
    
    var body: some View {
        switch reposService.loadingStatus {
        case .loading:
            ProgressView ()
        case .notLoading:
            EmptyView()
        }
    }
}

#Preview {
    LoadingRowView()
        .environment(ReposService())
}
