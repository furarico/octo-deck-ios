//
//  Community.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Foundation

struct Community: Hashable, Identifiable {
    let id: String
    let name: String
    let startAt: Date
    let endAt: Date
}

extension Community {
    static let stub0 = Community(
        id: "community-1",
        name: "Swift Developers",
        startAt: Date(),
        endAt: Date().addingTimeInterval(86400)
    )

    static let stub1 = Community(
        id: "community-2",
        name: "iOS Engineers",
        startAt: Date(),
        endAt: Date().addingTimeInterval(86400)
    )

    static let stubs = [stub0, stub1]
}
