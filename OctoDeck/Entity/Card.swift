//
//  Card.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/14.
//

import Foundation

struct Identicon: Decodable {
    let color: DomainColor
    let blocks: [[Bool]]
}

struct DomainColor: Decodable, Equatable {
    let r: Int
    let g: Int
    let b: Int
}

struct Card: Identifiable {
    let id: String
    let userName: String
    let fullName: String
    let iconUrl: URL?
    let identicon: Identicon
}
extension Card {
    static let stub0 = Card(
        id: "51151242",
        userName: "kantacky",
        fullName: "Kanta Oikawa",
        iconUrl: URL(string: "https://avatars.githubusercontent.com/u/51151242?v=4"),
        identicon: Identicon(color: DomainColor(r: <#T##Int#>, g: <#T##Int#>, b: <#T##Int#>), blocks: [[true]]) // RGBの値を設定
    )
}
