//
//  CardStackView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/15.
//

import SwiftUI

struct CardStackView: View {
    let cards: [Card]
    let onSelected: (_ card: Card) -> Void

    private let offsetY: CGFloat = 48

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    CardView(card: card)
                        .offset(y: CGFloat(index) * offsetY)
                        .onTapGesture {
                            onSelected(card)
                        }
                }
            }

            Color.clear
                .frame(height: CGFloat(cards.count - 1) * offsetY)
        }
    }
}

#Preview {
    CardStackView(
        cards: Card.stubs
    ) { _ in
    }
    .padding()
}
