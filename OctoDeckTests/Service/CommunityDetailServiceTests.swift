//
//  CommunityDetailServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct CommunityDetailServiceTests {
    @Test("HighlightedCardが正しく返却される")
    func testGetHighlightedCardSuccess() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let community = Community.stub0

        let service = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
        } operation: {
            CommunityDetailService()
        }

        let result = try await service.getHighlightedCard(id: community.id)
        #expect(result == expectedHighlightedCard)
    }

    @Test("HighlightedCardが返却されない")
    func testGetHighlightedCardFailure() async throws {
        let service = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                throw CommunityRepositoryError.apiError(404, nil)
            }
        } operation: {
            CommunityDetailService()
        }

        await #expect(throws: CommunityRepositoryError.self) {
            try await service.getHighlightedCard(id: "invalid-id")
        }
    }

    @Test("Cardsが正しく返却される")
    func testGetCardsSuccess() async throws {
        let expectedCards = Card.stubs

        let service = withDependencies {
            $0.communityRepository.getCommunityCards = { _ in
                expectedCards
            }
        } operation: {
            CommunityDetailService()
        }

        let result = try await service.getCards(id: Community.stub0.id)
        #expect(result == expectedCards)
    }

    @Test("Cardsが返却されない")
    func testGetCardsFailure() async throws {
        let service = withDependencies {
            $0.communityRepository.getCommunityCards = { _ in
                throw CommunityRepositoryError.apiError(404, nil)
            }
        } operation: {
            CommunityDetailService()
        }

        await #expect(throws: CommunityRepositoryError.self) {
            try await service.getCards(id: "invalid-id")
        }
    }
}
