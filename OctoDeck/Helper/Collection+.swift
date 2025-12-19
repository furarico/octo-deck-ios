//
//  Collection+.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
