//
//  SafariScreen.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/04.
//

import SwiftUI
import SafariServices

struct SafariScreen: UIViewControllerRepresentable {
    let url: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariScreen>) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: url)!)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariScreen>) {
        
    }
}

struct SafariScreen_Previews: PreviewProvider {
    static var previews: some View {
        SafariScreen(url: "https://example.com")
    }
}
