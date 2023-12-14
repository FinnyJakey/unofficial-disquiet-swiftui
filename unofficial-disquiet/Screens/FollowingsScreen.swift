//
//  FollowingsScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI
import FirebaseFirestore
import FirebaseMessaging

struct FollowingsScreen: View {
    @State private var followingAlert = false
    @State private var followingMaximumAlert = false
    @State private var followingMinimumAlert = false
    @State private var followingAlreadyAlert = false
    @State private var followingContainsSpaceAlert = false
    @State private var followingMustContainsAt = false
    
    @State private var followingText = ""
    @State private var deviceToken: String = ""
    
    @State private var followings: [String] = [String]()
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            List {
                if followings.isEmpty {
                    Text("새로운 아이디를 등록해 보세요!")
                }
                
                ForEach(followings, id: \.self) { following in
                    Text("@\(following)")
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            // MARK: db 삭제 and 다시 받아오기
                            Button {
                                db.collection("user").document(deviceToken).updateData([
                                    "following": FieldValue.arrayRemove([following])
                                ])
                                
                                // MARK: notification/following_maker_logs/followingText에서 삭제
                                db.collection("notification").document("following_maker_logs").updateData([
                                    "\(following)": FieldValue.arrayRemove([deviceToken])
                                ])
                                
                                db.collection("user").document(deviceToken).getDocument { (document, _) in
                                    if let document = document, document.exists {
                                        if let followings = document.data()?["following"] as? [String] {
                                            self.followings = followings
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .environment(\.symbolVariants, .none)
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("팔로잉 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if followings.count < 10 {
                            followingAlert.toggle()
                        } else {
                            followingMaximumAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .alert("아래에 아이디를 입력해주세요.", isPresented: $followingAlert) {
                        TextField("@username", text: $followingText)
                        Button("등록") {
                            Task {
                                await submit()
                            }
                        }
                        Button("취소", role: .cancel) {

                        }
                    }
                    .alert("아이디는 최대 10개까지 등록이 가능합니다!", isPresented: $followingMaximumAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("정확한 아이디를 입력해주세요!", isPresented: $followingMinimumAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("동일한 아이디는 등록할 수 없습니다!", isPresented: $followingAlreadyAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("아이디에 공백은 등록할 수 없습니다!", isPresented: $followingContainsSpaceAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("아이디 앞에 @가 들어가야 합니다!", isPresented: $followingMustContainsAt) {
                        Button("확인", role: .cancel) {

                        }
                    }
                }
            }
            .onAppear {
                // MARK: - get deviceToken
                Messaging.messaging().token { token, _ in
                    if let token = token {
                        deviceToken = token

                        // MARK: token으로 내 팔로잉 다 쪼사서 등록해야제
                        db.collection("user").document(token).getDocument { (document, _) in
                            if let document = document, document.exists {
                                if let followings = document.data()?["following"] as? [String] {
                                    self.followings = followings
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func submit() async {
        if followingText.count < 2 {
            followingMinimumAlert.toggle()
            followingText = ""
            return
        }
        
        if followingText.contains(" ") {
            followingContainsSpaceAlert.toggle()
            followingText = ""
            return
        }
        
        if !(followingText.first == "@") {
            followingMustContainsAt.toggle()
            followingText = ""
            return
        }
        
        followingText.remove(at: followingText.startIndex)
        
        if followings.contains(followingText) {
            followingAlreadyAlert.toggle()
            followingText = ""
            return
        }

        do {
            // MARK: db add & 다시 조회
            try await db.collection("user").document(deviceToken).updateData(["following": FieldValue.arrayUnion([followingText])])
            
            // MARK: notification/following_maker_logs/followingText에 업데이트
            let followingMakerLogsDoc = try await db.collection("notification").document("following_maker_logs").getDocument()
            
            if followingMakerLogsDoc.exists {
                try await db.collection("notification").document("following_maker_logs").updateData([
                    "\(followingText)": FieldValue.arrayUnion([deviceToken])
                ])
            }
            
            
            let deviceTokenDoc = try await db.collection("user").document(deviceToken).getDocument()
            
            if deviceTokenDoc.exists {
                if let followings = deviceTokenDoc.data()?["following"] as? [String] {
                    self.followings = followings
                }
            }
            
            followingText = ""
        } catch {
            
        }
    }
}

struct FollowingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowingsScreen()
    }
}
