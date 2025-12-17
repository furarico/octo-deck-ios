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
                throw StatisticRepositoryError.apiError(500, nil)
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
}

