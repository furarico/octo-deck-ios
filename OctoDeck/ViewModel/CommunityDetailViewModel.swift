//
//  CommunityDetailViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Observation

@Observable
@MainActor
final class CommunityDetailViewModel {
    let community: Community

    private(set) var highlightedCard: HighlightedCard? = nil
    private(set) var cards: [Card] = []
    private(set) var isLoading: Bool = false
    var selectedCard: Card? = nil
    private(set) var cardsInMyDeck: [Card] = []

    private let service = CommunityDetailService()

    init(community: Community) {
        self.community = community
    }

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }
        await refresh()
    }

    func onRefresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        await refresh()
    }

    private func refresh() async {
        do {
            async let highlightedCardTask = try await service.getHighlightedCard(id: community.id)
            async let cardsTask = try await service.getCardsInCommunity(id: community.id)
            async let cardsInMyDeckTask = try await service.getCardsInMyDeck()
            (highlightedCard, cards, cardsInMyDeck) = try await (highlightedCardTask, cardsTask, cardsInMyDeckTask)
        } catch {
            print(error)
        }
    }

    func onAddButtonTapped() {
        guard let selectedCard else {
            return
        }
        if cardsInMyDeck.contains(selectedCard) {
            cardsInMyDeck.removeAll(where: { $0.id == selectedCard.id })
        } else {
            cardsInMyDeck.append(selectedCard)
        }
    }

    func onCardTapped(_ card: Card) {
        selectedCard = card
    }
}
