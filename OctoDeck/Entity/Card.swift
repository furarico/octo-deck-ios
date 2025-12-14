//
//  Card.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/14.
//

struct Card: Identifiable, Equatable {
    let id: Int
    let userName: String
    let fullName: String
    let iconUrl: String
}
extension Card {
    //随時追加
    static let stub0 = Card(
        id: 1,
        userName: "",
        fullName: "",
        iconUrl: "",
    )
    static let stub1 = Card(
        id: 2,
        userName: "",
        fullName: "",
        iconUrl: "",
    )
    static let stub2 = Card(
        id: 3,
        userName: "",
        fullName: "",
        iconUrl: "",
    )

}
