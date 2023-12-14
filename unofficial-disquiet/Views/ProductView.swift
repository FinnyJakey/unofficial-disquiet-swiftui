//
//  ProductView.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    
    @EnvironmentObject private var safariModel: SafariModel

    var body: some View {
        VStack {
            // MARK: Header
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: product.uploader.profileImage)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 48, height: 48)
                }
                .padding(.trailing, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text(product.uploader.displayName)
                            .fontWeight(.semibold)
                            .padding(.trailing, 4)
                        
                        if let thumbnail = product.uploader.team?.thumbnail {
                            AsyncImage(url: URL(string: thumbnail)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .shadow(radius: 2)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.trailing, 4)
                        }
                        
                        Text("님이")
                            .foregroundColor(Color(hex: 0x8e8e8e))
                            .padding(.trailing, 4)
                        
                        Text("프로덕트")
                            .foregroundColor(Color(hex: 0x6d55ff))
                        
                        Text("를 공유했어요.")
                            .foregroundColor(Color(hex: 0x8e8e8e))
                    }
                    .lineLimit(1)
                    .font(.callout)
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(product.uploader.role)
                                .padding(.trailing, 2)
                            
                            if let employer = product.uploader.employer {
                                if !employer.isEmpty {
                                    Text("@\(employer)")
                                }
                            }
                        }
                        .lineLimit(1)
                        .padding(.trailing, 4)
                        
                        Text("•")
                            .padding(.trailing, 4)
                        // TODO: 시간 계산
                        Text(extractTimeFromString(writtenAt: product.createdAt))
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: 0x939394))
                }
                Spacer()
            }
            
            Button {
                safariModel.link = "https://disquiet.io/product/\(product.urlSlug.encodeUrl()!)"
                safariModel.isProductScreenActive.toggle()
            } label: {
                VStack(alignment: .leading) {
                    // MARK: Body
                    HStack {
                        AsyncImage(url: URL(string: product.thumbnail)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 1)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        }
                        .padding(.trailing, 6)
                        .padding(.bottom, 6)
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 4) {
                                // MARK: Topics
                                ForEach(product.topics, id: \.id) { topic in
                                    HStack(spacing: 2) {
                                        Text(topic.icon)
                                        Text(topic.displayName)
                                    }
                                    .font(.caption)
                                    .foregroundColor(Color(hex: 0x939394))
                                    .padding(6)
                                    .background(Color("BackgroundColor"))
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .lineLimit(1)
                            
                            Text(product.name)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(.bottom, 4)
                            
                            Text(product.tagline)
                                .font(.subheadline)
                            
                        }
                    }
                    .padding(.bottom, 8)
                    
                    // MARK: Footer
                    HStack {
                        // MARK: Comment
                        HStack {
                            Image(systemName: "bubble.left.fill")
                            Text("\(product.commentCount)")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // MARK: Reaction
                        HStack {
                            Image(systemName: "face.smiling.inverse")
                            Text("\(product.postReactionStat?.totalCount ?? 0)")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // MARK: Upvote
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("\(product.upvoteCount)")
                        }
                        .frame(maxWidth: .infinity)
                        
                        // MARK: Click
                        HStack {
                            Image(systemName: "cursorarrow.rays")
                            Text("\(product.viewCount)")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 8)
                    .font(.callout)
                    .foregroundColor(Color(hex: 0xacacac))
                }
                .padding()
                .background(Color("ItemBackgroundColor"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $safariModel.isProductScreenActive) {
                SafariScreen(url: safariModel.link)
            }
            
        }
        .padding()
    
    }
}

//struct ProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductView()
//    }
//}
