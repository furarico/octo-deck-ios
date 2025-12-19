//
//  CommunityDetailViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Observation

@Observable
final class CommunityDetailViewModel {
    let community: Community

    private(set) var highlightedCard: HighlightedCard? = nil
    private(set) var cards: [Card] = []
    private(set) var isLoading: Bool = false

    private let service = CommunityDetailService()

    init(community: Community) {
        self.community = community
    }

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            async let highlightedCardTask = try await service.getHighlightedCard(id: community.id)
            async let cardsTask = try await service.getCards(id: community.id)

            (highlightedCard, cards) = try await (highlightedCardTask, cardsTask)
        } catch {
            print(error)
        }
    }
}
