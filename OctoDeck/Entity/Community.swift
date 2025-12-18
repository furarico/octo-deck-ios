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
}

extension Community {
    static let stub0 = Community(
        id: "community-1",
        name: "Swift Developers"
    )

    static let stub1 = Community(
        id: "community-2",
        name: "iOS Engineers"
    )

    static let stubs = [stub0, stub1]
}
