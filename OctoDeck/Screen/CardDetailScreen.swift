//
//  CardDetailScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import SwiftUI

struct CardDetailScreen: View {
    private let card: Card
    @State private var viewModel: CardDetailViewModel

    init(card: Card) {
        self.card = card
        self.viewModel = CardDetailViewModel(card: card)
    }

    init(
        card: Card,
        viewModel: CardDetailViewModel
    ) {
        self.card = card
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let statistic = viewModel.statistic {
            ScrollView {
            }
        } else {
            Text("No statistic available.")
        }
    }
}

#Preview {
    CardDetailScreen(card: .stub0)
}
