//
//  Repository.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct APIResponse: Codable {
    let items: [Repository]
}

struct Repository: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let owner: Owner
}

struct Owner: Codable {
    let avatar_url: String?
}
