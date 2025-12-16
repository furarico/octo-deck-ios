//
//  DomainColor.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

struct DomainColor: Equatable {
    /// 0.0...1.0
    let r: Double
    /// 0.0...1.0
    let g: Double
    /// 0.0...1.0
    let b: Double
    
    /// 0...255 の値で初期化
    /// - Parameters:
    ///   - r: 赤 0...255
    ///   - g: 緑 0...255
    ///   - b: 青 0...255
    init(r: Int, g: Int, b: Int) {
        self.r = Double(r) / 255
        self.g = Double(g) / 255
        self.b = Double(b) / 255
    }
    
    /// 16進数カラーコードで初期化
    /// - Parameter hexCode: 16進数カラーコード #の有無は問わない (000000, #FFFFFF)
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

        self.r = Double((hexValue >> 16) & 0xFF) / 255
        self.g = Double((hexValue >> 8) & 0xFF) / 255
        self.b = Double(hexValue & 0xFF) / 255
    }
}

extension DomainColor {
    static let stub0 = DomainColor(r: 165, g: 219, b: 212)
}
