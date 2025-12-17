//
//  User.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

struct User: Equatable, Identifiable {
    /// GitHub ID
    let id: String
    /// GitHub Login
    let userName: String
    /// GitHub Name
    let fullName: String
}

extension User {
    static let stub0 = User(
        id: "1",
        userName: "octodeck-user",
        fullName: "Octo Deck"
    )
}
