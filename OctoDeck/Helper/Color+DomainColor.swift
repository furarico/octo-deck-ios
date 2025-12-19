//
//  Color+DomainColor.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import SwiftUI

extension Color {
    init(domainColor: DomainColor) {
        self.init(red: domainColor.r, green: domainColor.g, blue: domainColor.b)
    }
}
