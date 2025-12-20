//
//  CardDetailViewModelTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct CardDetailViewModelTests {
    @Test("初期状態が正しい")
    func testInitialState() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.statisticRepository.getUserStats = { _ in
                .stub
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        #expect(viewModel.card == card)
        #expect(viewModel.statistic == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでStatisticが正しく取得される")
    func testOnAppearSuccess() async throws {
        let card = Card.stub0
        let expectedStatistic = Statistic.stub

        let viewModel = withDependencies {
            $0.statisticRepository.getUserStats = { _ in
                expectedStatistic
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAppear()

        #expect(viewModel.card == card)
        #expect(viewModel.statistic == expectedStatistic)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでStatisticの取得に失敗した場合、statisticがnilのまま")
    func testOnAppearFailure() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.statisticRepository.getUserStats = { _ in
                throw StatisticRepositoryError.apiError(500)
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAppear()

        #expect(viewModel.card == card)
        #expect(viewModel.statistic == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("正しいgithubIdがServiceに渡される")
    func testOnAppearPassesCorrectGithubId() async throws {
        let card = Card.stub0
        let receivedGithubId = LockIsolated<String?>(nil)

        let viewModel = withDependencies {
            $0.statisticRepository.getUserStats = { githubId in
                receivedGithubId.setValue(githubId)
                return .stub
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAppear()

        #expect(receivedGithubId.value == card.id)
    }

    // MARK: - onAddButtonTapped

    @Test("初期状態でisDeckStatusLoadingがfalse")
    func testInitialDeckStatusLoading() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.statisticRepository.getUserStats = { _ in
                .stub
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        #expect(viewModel.isDeckStatusLoading == false)
    }

    @Test("onAddButtonTapped(isAdding: true)でaddCardToMyDeckが呼ばれる")
    func testOnAddButtonTappedAddSuccess() async throws {
        let card = Card.stub0
        let addCalled = LockIsolated(false)

        let viewModel = withDependencies {
            $0.cardRepository.addCardToMyDeck = { _ in
                addCalled.setValue(true)
                return .stub1
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAddButtonTapped(isAdding: true)

        #expect(addCalled.value == true)
        #expect(viewModel.isDeckStatusLoading == false)
    }

    @Test("onAddButtonTapped(isAdding: false)でremoveCardFromMyDeckが呼ばれる")
    func testOnAddButtonTappedRemoveSuccess() async throws {
        let card = Card.stub0
        let removeCalled = LockIsolated(false)

        let viewModel = withDependencies {
            $0.cardRepository.removeCardFromMyDeck = { _ in
                removeCalled.setValue(true)
                return .stub1
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAddButtonTapped(isAdding: false)

        #expect(removeCalled.value == true)
        #expect(viewModel.isDeckStatusLoading == false)
    }

    @Test("onAddButtonTapped(isAdding: true)で正しいgithubIdが渡される")
    func testOnAddButtonTappedAddPassesCorrectGithubId() async throws {
        let card = Card.stub0
        let receivedGithubId = LockIsolated<String?>(nil)

        let viewModel = withDependencies {
            $0.cardRepository.addCardToMyDeck = { githubId in
                receivedGithubId.setValue(githubId)
                return .stub1
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAddButtonTapped(isAdding: true)

        #expect(receivedGithubId.value == card.id)
    }

    @Test("onAddButtonTapped(isAdding: false)で正しいgithubIdが渡される")
    func testOnAddButtonTappedRemovePassesCorrectGithubId() async throws {
        let card = Card.stub0
        let receivedGithubId = LockIsolated<String?>(nil)

        let viewModel = withDependencies {
            $0.cardRepository.removeCardFromMyDeck = { githubId in
                receivedGithubId.setValue(githubId)
                return .stub1
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAddButtonTapped(isAdding: false)

        #expect(receivedGithubId.value == card.id)
    }

    @Test("onAddButtonTapped(isAdding: true)でエラーが発生してもクラッシュしない")
    func testOnAddButtonTappedAddFailure() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.cardRepository.addCardToMyDeck = { _ in
                throw StatisticRepositoryError.apiError(500)
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAddButtonTapped(isAdding: true)

        #expect(viewModel.isDeckStatusLoading == false)
    }

    @Test("onAddButtonTapped(isAdding: false)でエラーが発生してもクラッシュしない")
    func testOnAddButtonTappedRemoveFailure() async throws {
        let card = Card.stub0

        let viewModel = withDependencies {
            $0.cardRepository.removeCardFromMyDeck = { _ in
                throw StatisticRepositoryError.apiError(500)
            }
        } operation: {
            CardDetailViewModel(card: card)
        }

        await viewModel.onAddButtonTapped(isAdding: false)

        #expect(viewModel.isDeckStatusLoading == false)
    }
}

