//
//  MakerLog.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

// MARK: - MakerLog
struct MakerLog: Codable, Equatable {
    static func == (lhs: MakerLog, rhs: MakerLog) -> Bool {
        return lhs.id == rhs.id
    }
    
    let typename: String
    let id: Int
    let user: User
    let title: String?
    let shortBody, urlSlug: String
    let commentCount, upvoteCount, viewCount: Int
    let postReactionStat: PostReactionStat?
    let writtenAt: String

    enum CodingKeys: String, CodingKey {
        case typename = "__typename"
        case id, user, title
        case shortBody = "short_body"
        case urlSlug = "url_slug"
        case commentCount = "comment_count"
        case upvoteCount = "upvote_count"
        case viewCount = "view_count"
        case postReactionStat = "post_reaction_stat"
        case writtenAt = "written_at"
    }
}

// MARK: - PostResponse
struct PostResponseForMakerLog: Codable {
    let data: DataClassForMakerLog
}

// MARK: - DataClass
struct DataClassForMakerLog: Codable {
    let posts: [MakerLog]
}
