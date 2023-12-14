//
//  ProductScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI

struct ProductScreen: View {
    @ObservedObject var model: ProductModel
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
                
                TrendingProductsView(trendingProducts: model.trendingProducts, initiated: initiated)
                
                LazyVStack {
                    ForEach(model.posts, id: \.id) { post in
                        ProductView(product: post)
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
            .navigationTitle("프로덕트")
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
                    await model.getTrendingProducts()
                    initiated = true
                }
            }
            .refreshable {
                initiated = false
                page = 0
                model.posts.removeAll()
                
                Task {
                    await model.getPosts(page: page, sortOption: sortOption)
                    await model.getTrendingProducts()
                    initiated = true
                }
            }
        }
    }
}

struct ProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductScreen(model: ProductModel())
    }
}
