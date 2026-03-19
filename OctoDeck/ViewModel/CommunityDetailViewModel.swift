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

    private(set) var myCard: Card? = nil
    private(set) var isMember: Bool = false
    private(set) var isMembershipLoading: Bool = false
    var isDeleteConfirmationPresented: Bool = false
    private(set) var isDeleted: Bool = false

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
            async let myCardTask = try await service.getMyCard()
            (highlightedCard, cards, cardsInMyDeck, myCard) = try await (highlightedCardTask, cardsTask, cardsInMyDeckTask, myCardTask)
            isMember = cards.contains(where: { $0.id == myCard?.id })
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

    func onJoinButtonTapped() async {
        isMembershipLoading = true
        defer { isMembershipLoading = false }

        do {
            let card = try await service.joinCommunity(id: community.id)
            isMember = true
            cards.append(card)
        } catch {
            print(error)
        }
    }

    func onLeaveButtonTapped() async {
        isMembershipLoading = true
        defer { isMembershipLoading = false }

        do {
            let card = try await service.leaveCommunity(id: community.id)
            isMember = false
            cards.removeAll(where: { $0.id == card.id })
        } catch {
            print(error)
        }
    }

    func onDeleteConfirmed() async {
        do {
            try await service.deleteCommunity(id: community.id)
            isDeleted = true
        } catch {
            print(error)
        }
    }
}
