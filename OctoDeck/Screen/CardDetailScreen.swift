//
//  CardDetailScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Foundation
import SwiftUI

struct CardDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    private let card: Card
    private let isAdded: Bool
    private let onAddButtonTapped: () -> Void
    @State private var viewModel: CardDetailViewModel

    init(
        card: Card,
        isAdded: Bool,
        onAddButtonTapped: @escaping () -> Void
    ) {
        self.card = card
        self.isAdded = isAdded
        self.onAddButtonTapped = onAddButtonTapped
        self.viewModel = CardDetailViewModel(card: card)
    }

    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(role: .close) {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        addButtonTapped
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        shareLink
                    }
                }
                .background(
                    Image(.octoDeckBackground)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                )
        }
        .task {
            await viewModel.onAppear()
        }
    }

    @ViewBuilder
    private var content: some View {
        if let statistic = viewModel.statistic {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    CardView(card: viewModel.card)
                        .padding(.horizontal)

                    StatisticView(statistic: statistic)
                }
                .padding(.vertical)
                .refreshable {
                    await viewModel.onRefresh()
                }
            }
        } else if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ContentUnavailableView(
                "No Statistics",
                systemImage: "person.text.rectangle",
                description: Text("Card and/or statistics not available.")
            )
        }
    }

    private var addButtonTapped: some View {
        Button {
            Task {
                await viewModel.onAddButtonTapped(isAdding: !isAdded)
            }
            onAddButtonTapped()
        } label: {
            if viewModel.isDeckStatusLoading {
                ProgressView()
            } else {
                Image(systemName: isAdded ? "trash" : "plus")
            }
        }
        .disabled(viewModel.isDeckStatusLoading)
    }

    private var shareLink: some View {
        ShareLink(
            item: URL(string: "https://octodeck.furari.co/users/\(viewModel.card.id)")!,
            preview: SharePreview(
                viewModel.card.fullName
            )
        ) {
            Image(systemName: "square.and.arrow.up")
        }
    }
}

#Preview {
    CardDetailScreen(card: .stub0, isAdded: true) {
    }
}

#Preview {
    CardDetailScreen(card: .stub0, isAdded: false) {
    }
}
