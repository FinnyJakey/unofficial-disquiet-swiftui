//
//  ClubView.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI

struct ClubView: View {
    let club: Club
    
    @EnvironmentObject private var safariModel: SafariModel
    
    var body: some View {
        VStack {
            // MARK: Header
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: club.founder.profileImage)) { image in
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
                        Text(club.founder.displayName)
                            .fontWeight(.semibold)
                            .padding(.trailing, 4)
                        
                        if let thumbnail = club.founder.team?.thumbnail {
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
                        
                        Text("클럽")
                            .foregroundColor(Color(hex: 0xff3a72))
                        
                        Text("을 열었어요.")
                            .foregroundColor(Color(hex: 0x8e8e8e))
                    }
                    .lineLimit(1)
                    .font(.callout)
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(club.founder.role)
                                .padding(.trailing, 2)
                            
                            if let employer = club.founder.employer {
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
                        Text(extractTimeFromString(writtenAt: club.createdAt))
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: 0x939394))
                }
                Spacer()
            }
            
            Button {
                safariModel.link = "https://disquiet.io/club/\(club.urlSlug.encodeUrl()!)"
                safariModel.isClubScreenActive.toggle()
            } label: {
                VStack(alignment: .leading) {
                    // MARK: Body
                    HStack {
                        AsyncImage(url: URL(string: club.thumbnail)) { image in
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
                            Text(club.name)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(.bottom, 4)
                            
                            Text(club.description)
                                .lineLimit(4)
                                .font(.subheadline)
                            
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    // MARK: Footer
                    HStack(spacing: 14) {
                        // MARK: Type
                        HStack(spacing: 2) {
                            Image(systemName: "face.dashed.fill")
                            Text("유형: 클럽")
                        }

                        // MARK: Private
                        HStack(spacing: 2) {
                            Image(systemName: club.isPrivate ? "lock.fill" : "lock.open.fill")
                            Text(club.isPrivate ? "비공개" : "공개")
                        }

                        // MARK: Person Count
                        HStack(spacing: 2) {
                            Image(systemName: "person.3.fill")
                            Text("\(club.userCount)명 참여 중")
                        }
                    }
                    .padding(.vertical, 4)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: 0xacacac))
                }
                .padding()
                .background(Color("ItemBackgroundColor"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $safariModel.isClubScreenActive) {
                SafariScreen(url: safariModel.link)
            }
        }
        .padding()
    }
}

//struct ClubView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubView()
//    }
//}
