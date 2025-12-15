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
        VStack {
            ForEach(cards) { card in
                CardView(card: card)
            }
        }
    }
}
