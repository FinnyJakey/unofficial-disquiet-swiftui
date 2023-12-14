//
//  unofficial_disquietApp.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/11/30.
//

import SwiftUI

@main
struct unofficial_disquietApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var safariModel = SafariModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
                .environmentObject(safariModel)
        }
    }
}
