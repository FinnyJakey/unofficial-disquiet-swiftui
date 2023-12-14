//
//  SafariModel.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/04.
//

import Foundation

class SafariModel: ObservableObject {
    @Published var isMakerLogScreenActive: Bool = false
    @Published var isProductScreenActive: Bool = false
    @Published var isTrendingProductScreenActive: Bool = false
    @Published var isClubScreenActive: Bool = false
    
    @Published var link: String = ""
}
