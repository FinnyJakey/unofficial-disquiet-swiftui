//
//  TabViewScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/11/30.
//

import SwiftUI

struct TabViewScreen: View {
    @StateObject private var makerLogModel = MakerLogModel()
    @StateObject private var productModel = ProductModel()
    @StateObject private var clubModel = ClubModel()

    @State private var tabColor: Color = tabColors[0]
    @State private var selectedTabIndex = 0
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    var body: some View {
            TabView(selection: $selectedTabIndex) {
                MakerLogScreen(model: makerLogModel)
                    .tabItem {
                        Label("메이커로그", systemImage: "pencil.circle.fill")
                    }
                    .tag(0)
                ProductScreen(model: productModel)
                    .tabItem {
                        Label("프로덕트", systemImage: "cube.fill")
                    }
                    .tag(1)
                ClubScreen(model: clubModel)
                    .tabItem {
                        Label("클럽", systemImage: "checkerboard.shield")
                    }
                    .tag(2)
                SettingScreen()
                    .tabItem {
                        Label("설정", systemImage: "gear")
                    }
                    .tag(3)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tint(tabColors[selectedTabIndex])
            .sheet(isPresented: $appDelegate.tappedNotification) {
                SafariScreen(url: appDelegate.link)
            }
    }
}

struct TabViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabViewScreen()
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

fileprivate let tabColors: [Color] = [
    Color(hex: 0x6d55ff),
    Color(hex: 0x2f80ed),
    Color(hex: 0xff9700),
    .primary,
]
