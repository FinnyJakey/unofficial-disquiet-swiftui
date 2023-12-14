//
//  Topic.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

// MARK: - Topic
struct Topic: Codable {
    let id: Int
    let displayName: String
    let label: String
    let icon: String
        
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case label, icon
    }
}
