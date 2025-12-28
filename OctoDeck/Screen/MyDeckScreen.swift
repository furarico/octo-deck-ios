//
//  MyDeckScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import SwiftUI

struct MyDeckScreen: View {
    @State private var viewModel = MyDeckViewModel()
    @Binding private var card: Card?

    init(card: Binding<Card?>) {
        self._card = card
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
            .sheet(item: $viewModel.selectedCard) { card in
                CardDetailScreen(card: card, isAdded: viewModel.cardsInMyDeck.contains(card)) {
                    viewModel.onAddButtonTapped(card: card)
                }
            }
            .sheet(item: $card) { card in
                CardDetailScreen(card: card, isAdded: viewModel.cardsInMyDeck.contains(card)) {
                    viewModel.onAddButtonTapped(card: card)
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
    var content: some View {
        if let myCard = viewModel.myCard {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading) {
                        Text("My Card")
                            .font(.title)
                            .bold()

                        CardView(card: myCard)
                            .onTapGesture {
                                viewModel.onCardSelected(myCard)
                            }
                    }

                    VStack(alignment: .leading) {
                        Text("My Deck")
                            .font(.title)
                            .bold()

                        if viewModel.cardsInMyDeck.isEmpty {
                            ContentUnavailableView(
                                "No Cards",
                                systemImage: "person.3"
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            CardStackView(cards: viewModel.cardsInMyDeck) { card in
                                viewModel.onCardSelected(card)
                            }
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.onRefresh()
            }
        } else if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
                ContentUnavailableView(
                    "No Cards",
                    systemImage: "person.crop.rectangle.stack"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    MyDeckScreen(card: .constant(nil))
}
