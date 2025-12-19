//
//  CommunityDetailService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Dependencies

final actor CommunityDetailService {
    @Dependency(\.communityRepository) private var communityRepository

    func getHighlightedCard(id: Community.ID) async throws -> HighlightedCard {
        let (_, highlightedCard) = try await communityRepository.getCommunity(id: id)
        return highlightedCard
    }

    func getCards(id: Community.ID) async throws -> [Card] {
        try await communityRepository.getCommunityCards(id: id)
    }
}
