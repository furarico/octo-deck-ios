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

    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                CardView(card: card)
                    .offset(y: CGFloat(index) * 48)
                    .onTapGesture {
                        onSelected(card)
                    }
            }
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
