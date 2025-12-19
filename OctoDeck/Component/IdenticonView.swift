//
//  IdenticonView.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import SwiftUI

struct IdenticonView: View {
    private let identicon: Identicon
    private let opacities: [[CGFloat]]
    private var color: Color {
        let domainColor = identicon.color
        return Color(domainColor: domainColor)
    }

    init(
        identicon: Identicon,
        opacities: [[CGFloat]] = [
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
        ]
    ) {
        self.identicon = identicon
        self.opacities = opacities
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(identicon.blocks.enumerated(), id: \.offset) { row in
                HStack(spacing: 0) {
                    ForEach(row.element.enumerated(), id: \.offset) { col in
                        Color(col.element ? color : .clear)
                            .aspectRatio(1, contentMode: .fit)
                            .opacity(opacities[safe: row.offset]?[safe: col.offset] ?? 0)
                    }
                }
            }
        }
    }
}

#Preview {
    IdenticonView(identicon: .stub0)
}
