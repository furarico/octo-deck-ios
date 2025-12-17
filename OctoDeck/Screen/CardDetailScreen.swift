//
//  CardDetailScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Foundation
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
                HStack {
                    Button(role: .close) {
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .padding(8)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    Spacer()
                    shareLink
                }
            }
        } else {
            Text("No statistic available.")
        }
    }

    private var shareLink: some View {
        ShareLink(
            item: URL(string: "https://octodeck.furari.co/users/\(viewModel.card.id)")!,
            preview: SharePreview(
                viewModel.card.fullName
            )
        ) {
            Image(systemName: "square.and.arrow.up")
                .offset(y: -2)
                .font(.title3)
                .padding(4)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
    }
}

#Preview {
    CardDetailScreen(card: .stub0)
}
