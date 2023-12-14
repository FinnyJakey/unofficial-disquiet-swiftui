//
//  Club.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

// MARK: - Club
struct Club: Codable, Equatable {
    static func == (lhs: Club, rhs: Club) -> Bool {
        return lhs.id == rhs.id
    }
    
    let typename: String
    let id: Int
    let name, description, type, thumbnail, urlSlug: String
    let isPrivate: Bool
    let createdAt: String
    let founder: Founder
    let userCount: Int

    enum CodingKeys: String, CodingKey {
        case typename = "__typename"
        case id, name, description, type, thumbnail
        case urlSlug = "url_slug"
        case isPrivate = "is_private"
        case createdAt = "created_at"
        case founder
        case userCount = "user_count"
    }
}

// MARK: - PostResponse
struct PostResponseForClub: Codable {
    let data: DataClassForClub
}

// MARK: - DataClass
struct DataClassForClub: Codable {
    let posts: [Club]
}
