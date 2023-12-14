//
//  ContentView.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/11/30.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @State private var updatedNeeded = false
    
    let storeUrl = "https://apps.apple.com/us/app/unofficial-disquiet/id6473772519"
    let currentVersion = "1.0.0"
    
    let db = Firestore.firestore()
    
    var body: some View {
        TabViewScreen()
            .sheet(isPresented: $updatedNeeded) {
                UpdateSheetView(storeUrl: storeUrl)
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
            }
            .onAppear {
                db.collection("version").document("version").getDocument { (document, _) in
                    if let document = document, document.exists {
                        if let version = document.data()?["version"] as? String {
                            if currentVersion != version {
                                updatedNeeded.toggle()
                            }
                        }
                    }
                }
            }
    }
}

struct UpdateSheetView: View {
    let storeUrl: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("업데이트가 필요합니다!")
            Link("업데이트 하러 가기", destination: URL(string: storeUrl.encodeUrl()!)!)
                .buttonStyle(.borderedProminent)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var safariModel = SafariModel()
    
    static var previews: some View {
        ContentView()
    }
}
