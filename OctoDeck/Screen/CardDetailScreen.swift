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
        content
            .task {
                await viewModel.onAppear()
            }
            .background(
                Image(.octoDeckBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            )
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let statistic = viewModel.statistic {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        dismissButton
                        Spacer()
                        addButtonTapped
                        shareLink
                    }

                    VStack(alignment: .leading, spacing: 54) {
                        CardView(card: viewModel.card)

                        StatisticView(statistic: statistic)
                    }
                }
                .padding()
            }
        } else {
            ContentUnavailableView(
                "No Statistics",
                systemImage: "person.text.rectangle",
                description: Text("Card and/or statistics not available.")
            )
        }
    }

    private var dismissButton: some View {
        Button(role: .close) {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.primary)
                .frame(width: 48, height: 48)
                .font(.system(size: 24))
                .glassEffect()
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
                    .frame(width: 48, height: 48)
                    .glassEffect()
            } else {
                Image(systemName: isAdded ? "trash" : "plus")
                    .foregroundStyle(Color.primary)
                    .frame(width: 48, height: 48)
                    .font(.system(size: 24))
                    .glassEffect()
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
                .foregroundStyle(Color.primary)
                .frame(width: 48, height: 48)
                .font(.system(size: 24))
                .glassEffect()
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
