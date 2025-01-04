//
//  ViewHomeS2Mod.swift
//  PaperAppV2
//
//  Created by Sothesom on 15/10/1403.
//

import SwiftUI

struct ViewHomeS2Mod: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    var image: String
}

let ViewHomeS3: [ViewHomeS2Mod] = [
    .init(altText: "test1", image: "1"),
    .init(altText: "test2", image: "2"),
    .init(altText: "test3", image: "3"),
    .init(altText: "test4", image: "3")
]
