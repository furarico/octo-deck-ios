//
//  User.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

struct User: Equatable, Identifiable {
    /// GitHub ID
    let id: String
    /// GitHub Login
    let userName: String
    /// GitHub Name
    let fullName: String
    /// GitHub Avator
    let avatarUrl: URL?
}

extension User {
    static let stub0 = User(
        id: "51151242",
        userName: "kantacky",
        fullName: "Kanta Oikawa",
        avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/51151242?v=4")
    )
}
