//
//  Repository.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct SearchReposAPIResponse: Codable {
    let items: [SearchReposRepository]
}

struct SearchReposRepository: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let owner: Owner
    let stargazers_count: Int
    let pushed_at: String?
}

struct Owner: Codable {
    let avatar_url: String?
}
