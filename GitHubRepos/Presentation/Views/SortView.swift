//
//  SortView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/5/24.
//

import SwiftUI

struct SortView: View {
    @Environment(RepositoryViewModel.self) private var repoVM
    
    @State private var sort: SearchReposSort = RepositoryViewModel.getInitialSort()
    
    var body: some View {
        HStack {
            Picker("", selection: $sort) {
                ForEach(SearchReposSort.allCases, id: \.self) { sort in
                    Text(sort.rawValue)
                        .tag(sort)
                }
            }
            .disabled(repoVM.loadingStatus == .loading)
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            
            Button {
                switch repoVM.order {
                case .asc:
                    Task {
                        await repoVM.setOrder(.desc)
                    }
                case .desc:
                    Task {
                        await repoVM.setOrder(.asc)
                    }
                }
            } label: {
                Image(systemName: repoVM.order.icon)
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            .disabled(repoVM.loadingStatus == .loading)
            .padding(.trailing, 20)
        }
        .padding(.top, 8)
        .onChange(of: sort) { _, sort in
            Task {
                await repoVM.setSort(sort)
            }
        }
    }
}

#Preview {
    SortView()
        .environment(RepositoryViewModel())
}
