//
//  MyDeckViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Observation

@Observable
@MainActor
final class MyDeckViewModel {
    private(set) var myCard: Card?
    private(set) var cardsInMyDeck: [Card] = []
    private(set) var isLoading: Bool = false
    var selectedCard: Card?

    private let service = MyDeckService()

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }
        await refresh()
    }

    private func refresh() async {
        do {
            async let myCardTask = service.getMyCard()
            async let cardsInMyDeckTask = service.getCardsInMyDeck()
            (myCard, cardsInMyDeck) = try await (myCardTask, cardsInMyDeckTask)
        } catch {
            print(error)
        }
    }

    func onCardSelected(_ card: Card) {
        selectedCard = card
    }

    func onAddButtonTapped(card: Card) {
        if cardsInMyDeck.contains(card) {
            cardsInMyDeck.removeAll(where: { $0.id == card.id })
        } else {
            cardsInMyDeck.append(card)
        }
    }
}
