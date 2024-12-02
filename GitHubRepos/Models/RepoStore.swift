//
//  RepoStore.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI
import SwiftData

@Model
final class RepoStore {
    var id: String = UUID().uuidString
    var name: String = ""
    var repoDescription: String = ""
    var image: String = ""
    
    init(id: String, name: String, repoDescription: String, image: String) {
        self.id = id
        self.name = name
        self.repoDescription = repoDescription
        self.image = image
    }
}
