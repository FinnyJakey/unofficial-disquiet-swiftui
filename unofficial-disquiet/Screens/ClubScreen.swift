//
//  ClubScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI

struct ClubScreen: View {
    @ObservedObject var model: ClubModel
    @State var sortOption: SortOption = .popular
    @State var page: Int = 0
    @State var initiated: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if initiated == false {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
                LazyVStack {
                    ForEach(model.posts, id: \.id) { post in
                        ClubView(club: post)
                            .onAppear {
                                if initiated == false {
                                    return
                                }
                                
                                if post == model.posts[model.posts.count - 2] {
                                    Task {
                                        await model.getPosts(page: page.increase(), sortOption: sortOption)
                                    }
                                }
                            }
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("클럽")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("추천") {
                            if sortOption == .popular {
                                return
                            }
                            
                            sortOption = .popular
                            
                            initiated = false
                            page = 0
                            model.posts.removeAll()
                            
                            Task {
                                await model.getPosts(page: page, sortOption: sortOption)
                                initiated = true

                            }
                        }
                        
                        Button("최신") {
                            if sortOption == .recent {
                                return
                            }
                            
                            sortOption = .recent
                            
                            initiated = false
                            page = 0
                            model.posts.removeAll()
                            
                            Task {
                                await model.getPosts(page: page, sortOption: sortOption)
                                initiated = true
                            }
                            
                        }
                    } label: {
                        Text(sortOption == .popular ? "추천" : "최신")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await model.getPosts(page: page, sortOption: sortOption)
                    initiated = true
                }
            }
            .refreshable {
                initiated = false
                page = 0
                model.posts.removeAll()
                
                Task {
                    await model.getPosts(page: page, sortOption: sortOption)
                    initiated = true
                }
            }
        }
    }
}

struct ClubScreen_Previews: PreviewProvider {
    static var previews: some View {
        ClubScreen(model: ClubModel())
    }
}
