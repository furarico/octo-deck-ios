//
//  Language.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Foundation

struct Language: Equatable {
    let name: String
    let color: DomainColor
}

extension Language {
    static let stub0 = Language(
        name: "Swift",
        color: DomainColor(hexCode: "#F05138")
    )

    static let stub1 = Language(
        name: "TypeScript",
        color: DomainColor(hexCode: "#3178C6")
    )

    static let stubs = [stub0, stub1]
}
