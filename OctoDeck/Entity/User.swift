//
//  User.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

struct User: Equatable, Identifiable {
    let id: String
    let userName: String
    let fullName: String
}

extension User {
    static let stub0 = User(
        id: "1",
        userName: "octodeck-user",
        fullName: "Octo Deck"
    )
}
