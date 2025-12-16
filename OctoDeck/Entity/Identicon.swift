//
//  Identicon.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

struct Identicon: Equatable {
    let color: DomainColor
    let blocks: [[Bool]]
}

extension Identicon {
    static let stub0 = Identicon(
        color: .stub0,
        blocks: [
            [true, false, false, false, true],
            [false, false, true, false, false],
            [true, true, false, true, true],
            [true, false, true, false, true],
            [false, false, false, false, false],
        ]
    )
}
