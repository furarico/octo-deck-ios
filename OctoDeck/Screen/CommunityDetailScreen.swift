//
//  CommunityDetailScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import SwiftUI

struct CommunityDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CommunityDetailViewModel
    private let cardsColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    init(community: Community) {
        viewModel = CommunityDetailViewModel(community: community)
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
            .navigationTitle(viewModel.community.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if viewModel.isMembershipLoading {
                        ProgressView()
                    } else if viewModel.isMember {
                        Button("Leave") {
                            Task {
                                await viewModel.onLeaveButtonTapped()
                            }
                        }
                    } else {
                        Button("Join") {
                            Task {
                                await viewModel.onJoinButtonTapped()
                            }
                        }
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    ShareLink(
                        item: URL(string: "https://octodeck.furari.co/communities/\(viewModel.community.id)")!,
                        preview: SharePreview(viewModel.community.name)
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        viewModel.isDeleteConfirmationPresented = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .confirmationDialog(
                        "Delete Community",
                        isPresented: $viewModel.isDeleteConfirmationPresented,
                        titleVisibility: .visible
                    ) {
                        Button("Delete", role: .destructive) {
                            Task {
                                await viewModel.onDeleteConfirmed()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this community? This action cannot be undone.")
                    }
                }
            }
            .onChange(of: viewModel.isDeleted) {
                if viewModel.isDeleted {
                    dismiss()
                }
            }
            .sheet(item: $viewModel.selectedCard) { card in
                CardDetailScreen(card: card, isAdded: viewModel.cardsInMyDeck.contains(card)) {
                    viewModel.onAddButtonTapped()
                }
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
        if let highlightedCard = viewModel.highlightedCard {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading) {
                        Text("Highlighted Members")
                            .font(.title)
                            .bold()
                            .padding(.horizontal)

                        highlightedCardView(highlightedCard)
                    }

                    VStack(alignment: .leading) {
                        Text("All Members")
                            .font(.title)
                            .bold()
                            .padding(.horizontal)

                        cardsView(viewModel.cards)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.onRefresh()
            }
        } else if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ContentUnavailableView(
                "No Data",
                systemImage: "exclamationmark.triangle.fill",
                description: Text("Unable to load community data.")
            )
        }
    }

    private func highlightedCardView(_ highlightedCard: HighlightedCard) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Best Contributor")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestContributor, overrideColor: .init(hexCode: "#ffff24"))
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestContributor)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Committer")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestCommitter, overrideColor: .init(hexCode: "#4493f8"))
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestCommitter)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Reviewer")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestReviewer, overrideColor: .init(hexCode: "#da3633"))
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestReviewer)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Issuer")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestIssuer, overrideColor: .init(hexCode: "#238636"))
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestIssuer)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Pull Requester")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestPullRequester, overrideColor: .init(hexCode: "#8957e5"))
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestPullRequester)
                        }
                }
                .containerRelativeFrame(.horizontal)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.vertical)
        .safeAreaPadding(.horizontal, 16)
    }

    private func cardsView(_ cards: [Card]) -> some View {
        LazyVGrid(columns: cardsColumns, spacing: 16) {
            ForEach(cards) { card in
                CardView(card: card, isMini: true)
                    .onTapGesture {
                        viewModel.onCardTapped(card)
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommunityDetailScreen(community: .stub0)
    }
}
