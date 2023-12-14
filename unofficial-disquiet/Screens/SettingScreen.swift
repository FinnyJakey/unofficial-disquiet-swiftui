//
//  SettingScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI
import FirebaseFirestore
import FirebaseMessaging

struct SettingScreen: View {
    @State private var newLogAlert: Bool = false
    @State private var followingLogAlert: Bool = false
    
    @State private var showFollowings: Bool = false
    
    @State private var deviceToken: String = ""
    @State private var version: String?
    
    let db = Firestore.firestore()
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("새로운 메이커 로그 알림", isOn: $newLogAlert)
                        .onChange(of: newLogAlert) { value in
                            if value {
                                // MARK: FIREBASE user/device_token/new_maker_logs -> true
                                db.collection("user").document(deviceToken).updateData(["new_maker_logs": true])
                                
                                // MARK: notification/new_maker_logs/device_tokens -> if 안에 없으면 append
                                db.collection("notification").document("new_maker_logs").getDocument { (document, _) in
                                    if let document = document, document.exists {
                                        if let tokens = document.data()?["device_tokens"] as? [String] {
                                            if !tokens.contains(deviceToken) {
                                                db.collection("notification").document("new_maker_logs").updateData([
                                                    "device_tokens": FieldValue.arrayUnion([deviceToken])
                                                ])
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if !value {
                                // MARK: FIREBASE user/device_token/new_maker_logs -> false
                                db.collection("user").document(deviceToken).updateData(["new_maker_logs": false])
                                
                                // MARK: notification/new_maker_logs/device_tokens -> if 안에 있으면 remove
                                db.collection("notification").document("new_maker_logs").getDocument { (document, _) in
                                    if let document = document, document.exists {
                                        if let tokens = document.data()?["device_tokens"] as? [String] {
                                            if tokens.contains(deviceToken) {
                                                db.collection("notification").document("new_maker_logs").updateData([
                                                    "device_tokens": FieldValue.arrayRemove([deviceToken])
                                                ])
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .tint(.primary.opacity(0.5))
                } footer: {
                    Text("1시간 마다 새로운 메이커 로그 푸시 알림을 보내드립니다!")
                }
                
                Section {
                    Toggle("팔로잉 메이커 로그 알림", isOn: $followingLogAlert)
                        .onChange(of: followingLogAlert) { value in
                            if value {
                                db.collection("user").document(deviceToken).updateData(["following_maker_logs": true])
                            }
                            
                            if !value {
                                db.collection("user").document(deviceToken).updateData(["following_maker_logs": false])
                            }
                        }
                        .tint(.primary.opacity(0.5))
                } footer: {
                    Text("1시간 마다 등록한 메이커의 새로운 메이커 로그 푸시 알림을 보내드립니다!")
                }
                
                Section {
                    Link(destination: URL(string: "https://open.kakao.com/o/sNsW9gqd")!) {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("개발자에게 문의")
                            
                            Text("혹은 아샷추 사주기")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                } footer: {
                    Text("도움말 및 지원")
                }
                
                Section {
                    HStack {
                        Text("버전")
                        Spacer()
                        if let version = version {
                            Text(version)
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                        
                    }
                }
                
                Button {
                    pasteboard.string = deviceToken
                } label: {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("디바이스 토큰 복사")
                        
                        Text(deviceToken)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("설정")
            .toolbar {
                if followingLogAlert {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showFollowings.toggle()
                        } label: {
                            Image(systemName: "bell")
                        }
                        .sheet(isPresented: $showFollowings) {
                            FollowingsScreen()
                                .presentationDetents([.medium, .large])
                        }
                    }
                }
            }
            .onAppear {
                // MARK: - get version
                db.collection("version").document("version").getDocument { (document, _) in
                    if let document = document, document.exists {
                        if let version = document.data()?["version"] as? String {
                            self.version = version
                        }
                    }
                }
                
                // MARK: - get deviceToken
                Messaging.messaging().token { token, error in
                    if let error = error {
                        deviceToken = error.localizedDescription
                        print("Error fetching FCM registration token: \(error)")
                        
                    } else if let token = token {
                        deviceToken = token
                        
                        // MARK: - deviceToken으로 Firestore에서 true/false 찾아서 반영
                        db.collection("user").document(token).getDocument { (document, _) in
                            if let document = document, document.exists {
                                if let newMakerLogs = document.data()?["new_maker_logs"] as? Bool {
                                    self.newLogAlert = newMakerLogs
                                }
                                
                                if let followingMakerLogs = document.data()?["following_maker_logs"] as? Bool {
                                    self.followingLogAlert = followingMakerLogs
                                }
                            } else {
                                // MARK: - if current user has no user document
                                db.collection("user").document(token).setData([
                                    "following": [String](),
                                    "following_maker_logs": false,
                                    "new_maker_logs": false
                                ])
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingScreen()
    }
}
