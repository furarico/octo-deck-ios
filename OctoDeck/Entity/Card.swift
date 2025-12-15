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

extension DomainColor {
    init(id: String) {
        let hash = abs(id.hashValue)
        self.r = (hash >> 16) & 0xFF
        self.g = (hash >> 8) & 0xFF
        self.b = hash & 0xFF
    }
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
        identicon: Identicon(color: DomainColor(id: "51151242"), blocks: [[true]])
    )
}
