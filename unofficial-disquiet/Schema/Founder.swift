//
//  Founder.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

// MARK: - Founder
struct Founder: Codable {
    let id: Int
    let displayName: String
    let profileImage: String
    let role: String
    let employer: String?
    let username: String
    let team: Team?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case profileImage = "profile_image"
        case role, employer, username, team
    }
}
