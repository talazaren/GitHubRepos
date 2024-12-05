//
//  GHRepository.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI
import SwiftData

@Model
final class GHRepository {
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String = ""
    var repoDescription: String = ""
    var image: String = ""
    var stars: Int = 0
    var pushedAt: Date = Date()
    
    init(
        id: String = UUID().uuidString,
        name: String,
        repoDescription: String,
        image: String,
        stars: Int,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.repoDescription = repoDescription
        self.image = image
        self.stars = stars
        self.pushedAt = updatedAt
    }
}
