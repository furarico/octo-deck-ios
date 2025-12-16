//
//  IdentifiableURL.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

struct IdentifiableURL: Identifiable {
    let url: URL

    var id: String { url.absoluteString }
}
