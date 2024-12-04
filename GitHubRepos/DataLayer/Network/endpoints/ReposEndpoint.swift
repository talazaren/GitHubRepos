//
//  ReposEndpoint.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import SwiftUI

struct ReposEndpoint: Endpoint {
    var page: Int = 1
    var perPage: Int = Constants.perPage
    
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
        ["q": "swift", "sort": "stars", "order": "asc", "page": page, "per_page": perPage]
    }
}
