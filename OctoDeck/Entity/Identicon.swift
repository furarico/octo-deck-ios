//
//  Identicon.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

struct Identicon: Decodable {
    let color: DomainColor
    let blocks: [[Bool]]
}

extension Identicon {
    static let stub0 = Identicon(
        color: DomainColor(r: 165, g: 219, b: 212),
        blocks: [
            [true, false, false, false, true],
            [false, false, true, false, false],
            [true, true, false, true, true],
            [true, false, true, false, true],
            [false, false, false, false, false],
        ]
    )
}
