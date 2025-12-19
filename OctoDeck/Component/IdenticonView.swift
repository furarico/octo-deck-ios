//
//  IdenticonView.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import SwiftUI

struct IdenticonView: View {
    let identicon: Identicon
    private var color: Color {
        let domainColor = identicon.color
        return Color(red: domainColor.r, green: domainColor.g, blue: domainColor.b)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(identicon.blocks.enumerated(), id: \.offset) { row in
                HStack(spacing: 0) {
                    ForEach(row.element.enumerated(), id: \.offset) { col in
                        Color(col.element ? color : .clear)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }
}

#Preview {
    IdenticonView(identicon: .stub0)
}
