//
//  TrendingProduct.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

// MARK: - TrendingProduct
struct TrendingProduct: Codable {
    let id: Int
    let name, tagline, urlSlug, thumbnail: String
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case urlSlug = "url_slug"
        case thumbnail
        case isNew = "is_new"
    }
}

// MARK: - PostResponse
struct PostResponseForTrendingProduct: Codable {
    let data: DataClassForTrendingProduct
}

// MARK: - DataClass
struct DataClassForTrendingProduct: Codable {
    let trendingProducts: [TrendingProduct]
}
