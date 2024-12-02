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
            //Text(reposService.loadingStatus.rawValue)
            ProgressView {
                Text("Loading")
                    .foregroundColor(.pink)
                    .bold()
            }
        case .notLoading:
            //Text(reposService.loadingStatus.rawValue)
            EmptyView()
        }
    }
}

#Preview {
    LoadingRowView()
        .environment(ReposService())
}
