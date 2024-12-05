//
//  ReposEndpoint.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

enum SearchReposSort: String, CaseIterable {
    case stars = "stars"
    case updated = "updated"
}

enum SearchReposOrder: String {
    case asc = "asc"
    case desc = "desc"
    
    var icon: String {
        switch self {
        case .asc: return Constants.orderAsc
        case .desc: return Constants.orderDesc
        }
    }
}

struct ReposEndpoint: Endpoint {
    var page: Int = 1
    var perPage: Int = Constants.perPage
    var sort: SearchReposSort
    var order: SearchReposOrder = .asc
    
    var baseURL: URL {
        URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        "search/repositories"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String : Any]? {
        [
            "q": "swift",
            "sort": sort.rawValue,
            "order": order.rawValue,
            "page": page,
            "per_page": perPage
        ]
    }
}
