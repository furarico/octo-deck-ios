//
//  MyDeckService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies

final actor MyDeckService {
    @Dependency(\.cardRepository) private var cardRepository

    func getMyCard() async throws -> Card {
        try await cardRepository.getMyCard()
    }

    func getCardsInMyDeck() async throws -> [Card] {
        try await cardRepository.listCards()
    }
}
