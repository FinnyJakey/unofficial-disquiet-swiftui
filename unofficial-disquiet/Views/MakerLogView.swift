//
//  MakerLogView.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/11/30.
//

import SwiftUI
import WebKit

struct MakerLogView: View {
    let makerLog: MakerLog
    
    @EnvironmentObject private var safariModel: SafariModel
    
    @State private var loading = true
    @State var shortBody = ""
    
    var body: some View {
        ZStack {
            if loading == false {
                    VStack {
                        // MARK: Header
                        HStack(spacing: 0) {
                            AsyncImage(url: URL(string: makerLog.user.profileImage)) { image in
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
                                    Text(makerLog.user.displayName)
                                        .fontWeight(.semibold)
                                        .padding(.trailing, 4)
                                    
                                    if let thumbnail = makerLog.user.team?.thumbnail {
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
                                    
                                    Text("님의")
                                        .foregroundColor(Color(hex: 0x8e8e8e))
                                        .padding(.trailing, 4)
                                    
                                    Text("메이커로그")
                                        .foregroundColor(Color(hex: 0x1dce6b))
                                }
                                .lineLimit(1)
                                .font(.callout)
                                
                                HStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(makerLog.user.role)
                                            .padding(.trailing, 2)
                                        
                                        if let employer = makerLog.user.employer {
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
                                    Text(extractTimeFromString(writtenAt: makerLog.writtenAt))
                                }
                                .font(.caption)
                                .foregroundColor(Color(hex: 0x939394))
                            }
                            Spacer()
                        }
                        
                        Button {
                            safariModel.link = "https://disquiet.io/@\(makerLog.user.username)/makerlog/\(makerLog.urlSlug.encodeUrl()!)"
                            safariModel.isMakerLogScreenActive.toggle()
                        } label: {
                            VStack(alignment: .leading) {
                                // MARK: Body
                                VStack(alignment: .leading) {
                                    Text(makerLog.title ?? "")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.bottom)

                                    Text(shortBody)
                                        .lineLimit(12)
                                        .padding(.bottom)
                                }

                                // MARK: Footer
                                HStack {
                                    // MARK: Comment
                                    HStack {
                                        Image(systemName: "bubble.left.fill")
                                        Text("\(makerLog.commentCount)")
                                    }
                                    .frame(maxWidth: .infinity)

                                    // MARK: Reaction
                                    HStack {
                                        Image(systemName: "face.smiling.inverse")
                                        Text("\(makerLog.postReactionStat?.totalCount ?? 0)")
                                    }
                                    .frame(maxWidth: .infinity)

                                    // MARK: Upvote
                                    HStack {
                                        Image(systemName: "arrow.up.circle.fill")
                                        Text("\(makerLog.upvoteCount)")
                                    }
                                    .frame(maxWidth: .infinity)

                                    // MARK: Click
                                    HStack {
                                        Image(systemName: "cursorarrow.rays")
                                        Text("\(makerLog.viewCount)")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .font(.callout)
                                .foregroundColor(Color(hex: 0xacacac))
                            }
                            .padding()
                            .background(Color("ItemBackgroundColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $safariModel.isMakerLogScreenActive) {
                            SafariScreen(url: safariModel.link)
                        }
                    }
                    .padding()
                
            }
            
            if loading {
                VStack {
                    // MARK: Header
                    HStack(spacing: 0) {
                        AsyncImage(url: URL(string: makerLog.user.profileImage)) { image in
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
                                Text(makerLog.user.displayName)
                                    .fontWeight(.semibold)
                                    .padding(.trailing, 4)
                                
                                if let thumbnail = makerLog.user.team?.thumbnail {
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
                                
                                Text("님의")
                                    .foregroundColor(Color(hex: 0x8e8e8e))
                                    .padding(.trailing, 4)
                                
                                Text("메이커로그")
                                    .foregroundColor(Color(hex: 0x1dce6b))
                            }
                            .font(.callout)
                            
                            HStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(makerLog.user.role)
                                        .padding(.trailing, 2)
                                    
                                    if let employer = makerLog.user.employer {
                                        Text("@\(employer)")
                                    }
                                }
                                .lineLimit(1)
                                .padding(.trailing, 4)

                                Text("•")
                                    .padding(.trailing, 4)
                                // TODO: 시간 계산
                                Text(extractTimeFromString(writtenAt: makerLog.writtenAt))
                            }
                            .font(.caption)
                            .foregroundColor(Color(hex: 0x939394))
                        }
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        // MARK: Body
                        VStack(alignment: .leading) {
                            Text(makerLog.title ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom)
                            
                            Text(shortBody)
                                .lineLimit(12)
                                .padding(.bottom)
                        }
                        
                        // MARK: Footer
                        HStack {
                            // MARK: Comment
                            HStack {
                                Image(systemName: "bubble.left.fill")
                                Text("\(makerLog.commentCount)")
                            }
                            .frame(maxWidth: .infinity)
                            
                            // MARK: Reaction
                            HStack {
                                Image(systemName: "face.smiling.inverse")
                                Text("\(makerLog.postReactionStat?.totalCount ?? 0)")
                            }
                            .frame(maxWidth: .infinity)
                            
                            // MARK: Upvote
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("\(makerLog.upvoteCount)")
                            }
                            .frame(maxWidth: .infinity)
                            
                            // MARK: Click
                            HStack {
                                Image(systemName: "cursorarrow.rays")
                                Text("\(makerLog.viewCount)")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .font(.callout)
                        .foregroundColor(Color(hex: 0xacacac))
                    }
                    .padding()
                    .background(Color("ItemBackgroundColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
                .redacted(reason: .placeholder)
            }
        }
        .onAppear {
            Task {
                if let extractedText = await extractTextFromHTML(htmlString: makerLog.shortBody) {
                    shortBody = extractedText
                    loading = false
                } else {
                    print("Failed to extract text from HTML.")
                }
            }
        }
    }
}

//struct MakerLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakerLogView()
//    }
//}

func extractTextFromHTML(htmlString: String) async -> String? {
    do {
        guard let data = htmlString.prefix(800).data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                    continuation.resume(returning: attributedString)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return attributedString.string
    } catch {
        print("Error extracting text from HTML: \(error)")
        return nil
    }
}

func extractTimeFromString(writtenAt: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
    
    let writtenDate = dateFormatter.date(from: writtenAt)
    let now = Date()
    
    let interval = now - writtenDate!
    
    if interval.minute! < 60 {
        return "\(interval.minute!)분 전"
    }
    
    if interval.hour! < 24 {
        return "\(interval.hour!)시간 전"
    }
    
    if interval.day! < 8 {
        return "\(interval.day!)일 전"
    }
    
    if now.year == writtenDate!.year {
        return "\(writtenDate!.month)월 \(writtenDate!.day)일"
    }
    
    return "\(writtenDate!.year)년 \(writtenDate!.month)월 \(writtenDate!.day)일"
}

extension Date {
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
         return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
         return Calendar.current.component(.day, from: self)
    }

}

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    }
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
