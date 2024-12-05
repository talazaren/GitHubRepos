//
//  SortView.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/5/24.
//

import SwiftUI

struct SortView: View {
    @Environment(RepositoryViewModel.self) private var repoVM
    
    @Binding var sort: SearchReposSort
    
    var body: some View {
        HStack {
            Picker("", selection: $sort) {
                ForEach(SearchReposSort.allCases, id: \.self) { sort in
                    Text(sort.rawValue)
                        .tag(sort)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            
            Button {
                switch repoVM.order {
                case .asc:
                    repoVM.order = .desc
                case .desc:
                    repoVM.order = .asc
                }
            } label: {
                Image(systemName: repoVM.order.icon)
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    SortView(sort: .constant(.stars))
        .environment(RepositoryViewModel())
}
