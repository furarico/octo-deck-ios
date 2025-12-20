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
            $0.cardRepository.listCards = {
                Card.stubs
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.isLoading == false)
        #expect(viewModel.selectedCard == nil)
        #expect(viewModel.cardsInMyDeck == [])
    }

    // MARK: - onAppear

    @Test("onAppearでhighlightedCardとcardsとcardsInMyDeckが正しく取得される")
    func testOnAppearSuccess() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let expectedCards = Card.stubs
        let expectedCardsInMyDeck = [Card.stub0]
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { _ in
                expectedCards
            }
            $0.cardRepository.listCards = {
                expectedCardsInMyDeck
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == expectedHighlightedCard)
        #expect(viewModel.cards == expectedCards)
        #expect(viewModel.cardsInMyDeck == expectedCardsInMyDeck)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでhighlightedCardの取得に失敗した場合、全てnilまたは空配列のまま")
    func testOnAppearHighlightedCardFailure() async throws {
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                throw CommunityRepositoryError.apiError(404)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                Card.stubs
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.cardsInMyDeck == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでcardsの取得に失敗した場合、全てnilまたは空配列のまま")
    func testOnAppearCardsFailure() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { _ in
                throw CommunityRepositoryError.apiError(404)
            }
            $0.cardRepository.listCards = {
                Card.stubs
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.cardsInMyDeck == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでcardsInMyDeckの取得に失敗した場合、全てnilまたは空配列のまま")
    func testOnAppearCardsInMyDeckFailure() async throws {
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
            $0.cardRepository.listCards = {
                throw CardRepositoryError.apiError(404)
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == nil)
        #expect(viewModel.cards == [])
        #expect(viewModel.cardsInMyDeck == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでcardsが空配列の場合")
    func testOnAppearEmptyCards() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let expectedCardsInMyDeck = [Card.stub0]
        let community = Community.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { _ in
                []
            }
            $0.cardRepository.listCards = {
                expectedCardsInMyDeck
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(viewModel.highlightedCard == expectedHighlightedCard)
        #expect(viewModel.cards == [])
        #expect(viewModel.cardsInMyDeck == expectedCardsInMyDeck)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearで異なるcommunity IDが正しく渡される")
    func testOnAppearWithDifferentCommunity() async throws {
        let expectedHighlightedCard = HighlightedCard.stub0
        let expectedCards = Card.stubs
        let expectedCardsInMyDeck = [Card.stub1]
        let community = Community.stub1

        let receivedCommunityId = LockIsolated<String?>(nil)
        let receivedCardsId = LockIsolated<String?>(nil)

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { id in
                receivedCommunityId.setValue(id)
                return (community, expectedHighlightedCard)
            }
            $0.communityRepository.getCommunityCards = { id in
                receivedCardsId.setValue(id)
                return expectedCards
            }
            $0.cardRepository.listCards = {
                expectedCardsInMyDeck
            }
        } operation: {
            CommunityDetailViewModel(community: community)
        }

        await viewModel.onAppear()

        #expect(receivedCommunityId.value == community.id)
        #expect(receivedCardsId.value == community.id)
        #expect(viewModel.highlightedCard == expectedHighlightedCard)
        #expect(viewModel.cards == expectedCards)
        #expect(viewModel.cardsInMyDeck == expectedCardsInMyDeck)
    }

    // MARK: - onCardTapped

    @Test("onCardTappedでselectedCardが正しく設定される")
    func testOnCardTapped() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        #expect(viewModel.selectedCard == nil)

        viewModel.onCardTapped(card)

        #expect(viewModel.selectedCard == card)
    }

    @Test("onCardTappedで別のカードをタップするとselectedCardが更新される")
    func testOnCardTappedUpdatesSelection() async throws {
        let card0 = Card.stub0
        let card1 = Card.stub1

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        viewModel.onCardTapped(card0)
        #expect(viewModel.selectedCard == card0)

        viewModel.onCardTapped(card1)
        #expect(viewModel.selectedCard == card1)
    }

    // MARK: - onAddButtonTapped

    @Test("onAddButtonTappedでselectedCardがnilの場合、何も起こらない")
    func testOnAddButtonTappedWithNoSelection() async throws {
        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        #expect(viewModel.selectedCard == nil)
        #expect(viewModel.cardsInMyDeck == [])

        viewModel.onAddButtonTapped()

        #expect(viewModel.cardsInMyDeck == [])
    }

    @Test("onAddButtonTappedでカードがデッキにない場合、追加される")
    func testOnAddButtonTappedAddsCard() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        viewModel.onCardTapped(card)
        #expect(viewModel.cardsInMyDeck == [])

        viewModel.onAddButtonTapped()

        #expect(viewModel.cardsInMyDeck.count == 1)
        #expect(viewModel.cardsInMyDeck.contains(card))
    }

    @Test("onAddButtonTappedでカードが既にデッキにある場合、削除される")
    func testOnAddButtonTappedRemovesCard() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                [card]
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        await viewModel.onAppear()

        #expect(viewModel.cardsInMyDeck.contains(card))

        viewModel.onCardTapped(card)
        viewModel.onAddButtonTapped()

        #expect(!viewModel.cardsInMyDeck.contains(card))
    }

    @Test("onAddButtonTappedでトグル動作が正しく機能する")
    func testOnAddButtonTappedToggle() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        viewModel.onCardTapped(card)

        // 追加
        viewModel.onAddButtonTapped()
        #expect(viewModel.cardsInMyDeck.contains(card))

        // 削除
        viewModel.onAddButtonTapped()
        #expect(!viewModel.cardsInMyDeck.contains(card))

        // 再追加
        viewModel.onAddButtonTapped()
        #expect(viewModel.cardsInMyDeck.contains(card))
    }

    @Test("onAddButtonTappedで他のカードに影響を与えない")
    func testOnAddButtonTappedDoesNotAffectOtherCards() async throws {
        let card0 = Card.stub0
        let card1 = Card.stub1

        let viewModel = withDependencies {
            $0.communityRepository.getCommunity = { _ in
                (.stub0, .stub0)
            }
            $0.communityRepository.getCommunityCards = { _ in
                Card.stubs
            }
            $0.cardRepository.listCards = {
                [card1]
            }
        } operation: {
            CommunityDetailViewModel(community: .stub0)
        }

        await viewModel.onAppear()

        #expect(viewModel.cardsInMyDeck.contains(card1))
        #expect(!viewModel.cardsInMyDeck.contains(card0))

        viewModel.onCardTapped(card0)
        viewModel.onAddButtonTapped()

        #expect(viewModel.cardsInMyDeck.contains(card0))
        #expect(viewModel.cardsInMyDeck.contains(card1))
        #expect(viewModel.cardsInMyDeck.count == 2)
    }
}
