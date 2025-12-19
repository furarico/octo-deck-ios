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
}
