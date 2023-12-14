//
//  MakerLogModel.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import Foundation

class MakerLogModel: ObservableObject {
    private let endpoint = "https://api.disquiet.io/graphql"
    @Published var posts: [MakerLog] = []
    
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
            ... on MakerLog {
              id
              user {
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
              title
              short_body
              url_slug
              comment_count
              upvote_count
              view_count
              post_reaction_stat {
                total_count
                __typename
              }
              written_at
            }
          }
        }
        """
        
        var variables: [String: Any] = [
            "offset": page * 12,
            "limit": 12,
            "type": "maker_log",
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
                let decodedData = try decoder.decode(PostResponseForMakerLog.self, from: data)
                let makerLogs = decodedData.data.posts
                
                DispatchQueue.main.async {    
                    self.posts.append(contentsOf: makerLogs)
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
