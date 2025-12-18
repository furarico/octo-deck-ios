//
//  CardDetailService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies

final actor CardDetailService {
    @Dependency(\.cardRepository) private var cardRepository
    @Dependency(\.statisticRepository) private var statisticRepository

    func getStatistic(of githubId: String) async throws -> Statistic {
        try await statisticRepository.getUserStats(githubId: githubId)
    }

    func addCardToMyDeck(githubId: String) async throws -> Card {
        try await cardRepository.addCardToMyDeck(id: githubId)
    }

    func removeCardFromMyDeck(githubId: String) async throws -> Card {
        try await cardRepository.removeCardFromMyDeck(id: githubId)
    }
}
