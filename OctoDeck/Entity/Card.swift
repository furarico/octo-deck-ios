//
//  Card.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/14.
//

import Foundation

struct Card: Equatable, Identifiable {
    /// GitHub ID
    let id: String
    let userName: String
    let fullName: String
    let iconUrl: URL?
    let identicon: Identicon
    let mostUsedLanguage: Language
}

extension Card {
    static let stub0 = Card(
        id: "51151242",
        userName: "kantacky",
        fullName: "Kanta Oikawa",
        iconUrl: URL(string: "https://avatars.githubusercontent.com/u/51151242?v=4"),
        identicon: .stub0,
        mostUsedLanguage: .stub0
    )

    static let stub1 = Card(
        id: "136790650",
        userName: "masaya-osuga",
        fullName: "Masaya Osuga",
        iconUrl: URL(string: "https://avatars.githubusercontent.com/u/136790650?v=4"),
        identicon: .stub0,
        mostUsedLanguage: .stub1
    )

    static let stubs = [stub0, stub1]
}
