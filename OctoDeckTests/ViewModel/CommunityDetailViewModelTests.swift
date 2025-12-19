//
//  CommunityDetailViewModelTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/19.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct CommunityDetailViewModelTests {
    // MARK: - 初期状態

    @Test("初期状態が正しい")
    func testInitialState() async throws {
        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.isLoading == false)
    }

    // MARK: - onAppear

    @Test("onAppearでhighlightedCardとcardsが正しく取得される")
    func testOnAppearSuccess() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let expectedCards = Card.stubs
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { _ in
                expectedCards
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == expectedHighlightedCard)
        #expect(viewModel.cards == expectedCards)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでhighlightedCardの取得に失敗した場合、両方nilまたは空配列のまま")
    func testOnAppearHighlightedCardFailure() async throws {
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                throw CommunityRepositoryError.apiError(404, nil)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでcardsの取得に失敗した場合、両方nilまたは空配列のまま")
    func testOnAppearCardsFailure() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { _ in
                throw CommunityRepositoryError.apiError(404, nil)
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでcardsが空配列の場合")
    func testOnAppearEmptyCards() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { _ in
                []
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == expectedHighlightedCard)
        #expect(viewModel.cards == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearで異なるcommunity IDが正しく渡される")
    func testOnAppearWithDifferentCommunity() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let expectedCards = Card.stubs
        let community = Community.stub1

        var receivedCommunityId: String?
        var receivedCardsId: String?

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { id in
                receivedCommunityId = id
                return (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { id in
                receivedCardsId = id
                return expectedCards
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(receivedCommunityId == community.id)
        #expect(receivedCardsId == community.id)
        #expect(viewModel.highlightedCard == expectedHighlightedCard)
        #expect(viewModel.cards == expectedCards)
    }
}
