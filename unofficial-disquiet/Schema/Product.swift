//
//  Product.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

// MARK: - Product
struct Product: Codable, Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    let typename: String
    let id: Int
    let uploader: Uploader
    let urlSlug, name, tagline, thumbnail: String
    let commentCount, upvoteCount, viewCount: Int
    let topics: [Topic]
    let postReactionStat: PostReactionStat?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case typename = "__typename"
        case id, uploader
        case urlSlug = "url_slug"
        case name, tagline, thumbnail
        case commentCount = "comment_count"
        case upvoteCount = "upvote_count"
        case viewCount = "view_count"
        case topics
        case postReactionStat = "post_reaction_stat"
        case createdAt = "created_at"
    }
}

// MARK: - PostResponse
struct PostResponseForProduct: Codable {
    let data: DataClassForProduct
}

// MARK: - DataClass
struct DataClassForProduct: Codable {
    let posts: [Product]
}
