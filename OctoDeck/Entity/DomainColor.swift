//
//  DomainColor.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

struct DomainColor: Decodable, Equatable {
    let r: Int
    let g: Int
    let b: Int

    init(hexCode: String) {
        var hex = hexCode
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }

        guard
            hex.count == 6,
            let hexValue = UInt64(hex, radix: 16)
        else {
            self.r = 0
            self.g = 0
            self.b = 0
            return
        }

        self.r = Int((hexValue >> 16) & 0xFF)
        self.g = Int((hexValue >> 8) & 0xFF)
        self.b = Int(hexValue & 0xFF)
    }
}
