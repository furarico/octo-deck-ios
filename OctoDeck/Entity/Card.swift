//
//  Card.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/14.
//

struct Card: Identifiable, Equatable {
    let id: String
    let userName: String
    let fullName: String
    let iconUrl: String
}
extension Card {
    static let stub0 = Card(
        id: "51151242",
        userName: "kantacky",
        fullName: "Kanta Oikawa",
        iconUrl: "https://avatars.githubusercontent.com/u/51151242?v=4",
    )
    //随時追加
    static let stub1 = Card(
        id: "",
        userName: "",
        fullName: "",
        iconUrl: "",
    )
    static let stub2 = Card(
        id: "",
        userName: "",
        fullName: "",
        iconUrl: "",
    )
}
