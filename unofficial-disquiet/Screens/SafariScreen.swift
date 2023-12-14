//
//  WebViewRepresentableScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/04.
//

import SwiftUI
import WebKit

struct WebViewRepresentableScreen: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebViewRepresentableScreen>) {
        
    }
}

struct WebViewRepresentableScreen_Previews: PreviewProvider {
    static var previews: some View {
        WebViewRepresentableScreen(url: "https://example.com")
    }
}
