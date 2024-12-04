//
//  LoadingRowView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct LoadingRowView: View {
    @Environment(RepositoryViewModel.self) private var repoVM
    
    var body: some View {
        switch repoVM.loadingStatus {
        case .loading:
            ProgressView ()
        case .notLoading:
            EmptyView()
        }
    }
}

#Preview {
    LoadingRowView()
        .environment(RepositoryViewModel())
}
