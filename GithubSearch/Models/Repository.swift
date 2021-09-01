//
//  Repositiory.swift
//
//  Created by Erwin Robles on 8/29/21.
//

import UIKit

struct Repositories: Decodable {
    var page: Int?
    var totalCount: Int?
    var items: [Repository]?
    
    var isAllItemsLoaded: Bool {
        return totalCount == items?.count
    }
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct Repository: Decodable {
    let fullName, description, language, pushedAt, htmlUrl: String?
    let stargazersCount: Int?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case language
        case stargazersCount = "stargazers_count"
        case pushedAt = "pushed_at"
        case htmlUrl = "html_url"
    }
}
