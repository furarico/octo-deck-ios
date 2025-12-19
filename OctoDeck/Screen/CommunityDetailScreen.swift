//
//  CommunityDetailScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import SwiftUI

struct CommunityDetailScreen: View {
    @State private var viewModel: CommunityDetailViewModel

    init(community: Community) {
        viewModel = CommunityDetailViewModel(community: community)
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
            .navigationTitle(viewModel.community.name)
            .sheet(item: $viewModel.selectedCard) { card in
                CardDetailScreen(card: card, isAdded: viewModel.cardsInMyDeck.contains(card)) {
                    viewModel.onAddButtonTapped()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    if let highlightedCard = viewModel.highlightedCard {
                        VStack(alignment: .leading) {
                            Text("Highlighted Members")
                                .font(.title)
                                .bold()
                                .padding(.horizontal)

                            highlightedCardView(highlightedCard)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("All Members")
                            .font(.title)
                            .bold()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }

    private func highlightedCardView(_ highlightedCard: HighlightedCard) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Best Contributor")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestContributor)
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestContributor)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Committer")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestCommitter)
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestCommitter)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Reviewer")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestReviewer)
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestReviewer)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Issuer")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestIssuer)
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestIssuer)
                        }
                }
                .containerRelativeFrame(.horizontal)

                VStack(alignment: .leading) {
                    Text("Best Pull Requester")
                        .font(.title2)
                        .bold()
                    CardView(card: highlightedCard.bestPullRequester)
                        .onTapGesture {
                            viewModel.onCardTapped(highlightedCard.bestPullRequester)
                        }
                }
                .containerRelativeFrame(.horizontal)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        CommunityDetailScreen(community: .stub0)
    }
}
