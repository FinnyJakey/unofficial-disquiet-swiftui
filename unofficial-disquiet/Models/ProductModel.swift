//
//  ProductModel.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

class ProductModel: ObservableObject {
    private let endpoint = "https://api.disquiet.io/graphql"
    @Published var posts: [Product] = []
    @Published var trendingProducts: [TrendingProduct] = []

    func getPosts(page: Int, sortOption: SortOption) async {
        guard let url = URL(string: endpoint) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let query = """
        query GetPosts($offset: Int, $limit: Int, $sortOption: String, $type: String, $period: String) {
          posts(
            offset: $offset
            limit: $limit
            sortOption: $sortOption
            type: $type
            period: $period
          ) {
            __typename
            ... on Product {
              id
              uploader {
                id
                display_name
                profile_image
                role
                employer
                username
                team {
                  id
                  name
                  thumbnail
                  __typename
                }
                __typename
              }
              url_slug
              name
              tagline
              thumbnail
              comment_count
              upvote_count
              view_count
              topics {
                id
                display_name
                label
                icon
                __typename
              }
              post_reaction_stat {
                total_count
                __typename
              }
              created_at
              __typename
            }
          }
        }
        """
        
        var variables: [String: Any] = [
            "offset": page * 12,
            "limit": 12,
            "type": "product",
            "sortOption": sortOption.rawValue,
        ]
                        
        if sortOption == .popular {
            variables["period"] = "week"
        }

        let requestBody: [String: Any] = ["query": query, "variables": variables]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(PostResponseForProduct.self, from: data)
                let products = decodedData.data.posts
                
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: products)
                }
                
            } catch {
                print("Error: \(error)")
                return
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getTrendingProducts() async {
        guard let url = URL(string: endpoint) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let query = """
        query GetTrendingProducts($limit: Int) {
          trendingProducts(limit: $limit) {
            id
            name
            tagline
            url_slug
            thumbnail
            is_new
            __typename
          }
        }
        """
        
        let variables: [String: Any] = [
            "limit": 5,
        ]

        let requestBody: [String: Any] = ["query": query, "variables": variables]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(PostResponseForTrendingProduct.self, from: data)
                let trendingProducts = decodedData.data.trendingProducts
                
                DispatchQueue.main.async {
                    self.trendingProducts = trendingProducts
                }
                
            } catch {
                print("Error: \(error)")
                return
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
}
