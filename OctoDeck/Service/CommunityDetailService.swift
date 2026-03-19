//
//  CommunityDetailService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Dependencies

final actor CommunityDetailService {
    @Dependency(\.cardRepository) private var cardRepository
    @Dependency(\.communityRepository) private var communityRepository

    func getHighlightedCard(id: Community.ID) async throws -> HighlightedCard {
        let (_, highlightedCard) = try await communityRepository.getCommunity(id: id)
        return highlightedCard
    }

    func getCardsInCommunity(id: Community.ID) async throws -> [Card] {
        try await communityRepository.getCommunityCards(id: id)
    }

    func getCardsInMyDeck() async throws -> [Card] {
        try await cardRepository.listCards()
    }

    func getMyCard() async throws -> Card {
        try await cardRepository.getMyCard()
    }

    func deleteCommunity(id: Community.ID) async throws {
        _ = try await communityRepository.deleteCommunity(id: id)
    }

    func joinCommunity(id: Community.ID) async throws -> Card {
        try await communityRepository.addCardToCommunity(id: id)
    }

    func leaveCommunity(id: Community.ID) async throws -> Card {
        try await communityRepository.removeCardFromCommunity(id: id)
    }
}
