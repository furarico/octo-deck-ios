//
//  CardStackView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/15.
//

import SwiftUI

struct CardStackView: View {
    let cards: [Card]

    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                CardView(card: card)
                    .offset(y: offsetY(index: index))
            }
        }
    }

    private func offsetY(index: Int) -> CGFloat {
        let totalCards = cards.count
        let reverseIndex = CGFloat(totalCards - 1 - index)
        return reverseIndex * -48
    }
}

#Preview {
    CardStackView(
        cards: Card.stubs
    )
    .padding()
}
