//
//  CardDetailServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct CardDetailServiceTests {
    @Test("Statisticが正しく返却される")
    func testGetStatisticSuccess() async throws {
        let expected = Statistic.stub
        let githubId = "testuser"

        let service = withDependencies {
            $0.statisticRepository.getUserStats = { _ in
                expected
            }
        } operation: {
            CardDetailService()
        }

        #expect(try await service.getStatistic(of: githubId) == expected)
    }

    @Test("Statisticが返却されない")
    func testGetStatisticFailure() async throws {
        let githubId = "testuser"

        let service = withDependencies {
            $0.statisticRepository.getUserStats = { _ in
                throw StatisticRepositoryError.apiError(500)
            }
        } operation: {
            CardDetailService()
        }

        await #expect(throws: StatisticRepositoryError.self) {
            try await service.getStatistic(of: githubId)
        }
    }

    @Test("正しいgithubIdがRepositoryに渡される")
    func testGetStatisticPassesCorrectGithubId() async throws {
        let expectedGithubId = "octocat"
        let receivedGithubId = LockIsolated<String?>(nil)

        let service = withDependencies {
            $0.statisticRepository.getUserStats = { githubId in
                receivedGithubId.setValue(githubId)
                return .stub
            }
        } operation: {
            CardDetailService()
        }

        _ = try await service.getStatistic(of: expectedGithubId)

        #expect(receivedGithubId.value == expectedGithubId)
    }

    // MARK: - addCardToMyDeck

    @Test("addCardToMyDeckでCardが正しく返却される")
    func testAddCardToMyDeckSuccess() async throws {
        let expected = Card.stub1
        let githubId = "testuser"

        let service = withDependencies {
            $0.cardRepository.addCardToMyDeck = { _ in
                expected
            }
        } operation: {
            CardDetailService()
        }

        #expect(try await service.addCardToMyDeck(githubId: githubId) == expected)
    }

    @Test("addCardToMyDeckでエラーが発生する")
    func testAddCardToMyDeckFailure() async throws {
        let githubId = "testuser"

        let service = withDependencies {
            $0.cardRepository.addCardToMyDeck = { _ in
                throw StatisticRepositoryError.apiError(500)
            }
        } operation: {
            CardDetailService()
        }

        await #expect(throws: StatisticRepositoryError.self) {
            try await service.addCardToMyDeck(githubId: githubId)
        }
    }

    @Test("addCardToMyDeckで正しいgithubIdがRepositoryに渡される")
    func testAddCardToMyDeckPassesCorrectGithubId() async throws {
        let expectedGithubId = "octocat"
        let receivedGithubId = LockIsolated<String?>(nil)

        let service = withDependencies {
            $0.cardRepository.addCardToMyDeck = { githubId in
                receivedGithubId.setValue(githubId)
                return .stub1
            }
        } operation: {
            CardDetailService()
        }

        _ = try await service.addCardToMyDeck(githubId: expectedGithubId)

        #expect(receivedGithubId.value == expectedGithubId)
    }

    // MARK: - removeCardFromMyDeck

    @Test("removeCardFromMyDeckでCardが正しく返却される")
    func testRemoveCardFromMyDeckSuccess() async throws {
        let expected = Card.stub1
        let githubId = "testuser"

        let service = withDependencies {
            $0.cardRepository.removeCardFromMyDeck = { _ in
                expected
            }
        } operation: {
            CardDetailService()
        }

        #expect(try await service.removeCardFromMyDeck(githubId: githubId) == expected)
    }

    @Test("removeCardFromMyDeckでエラーが発生する")
    func testRemoveCardFromMyDeckFailure() async throws {
        let githubId = "testuser"

        let service = withDependencies {
            $0.cardRepository.removeCardFromMyDeck = { _ in
                throw StatisticRepositoryError.apiError(500)
            }
        } operation: {
            CardDetailService()
        }

        await #expect(throws: StatisticRepositoryError.self) {
            try await service.removeCardFromMyDeck(githubId: githubId)
        }
    }

    @Test("removeCardFromMyDeckで正しいgithubIdがRepositoryに渡される")
    func testRemoveCardFromMyDeckPassesCorrectGithubId() async throws {
        let expectedGithubId = "octocat"
        let receivedGithubId = LockIsolated<String?>(nil)

        let service = withDependencies {
            $0.cardRepository.removeCardFromMyDeck = { githubId in
                receivedGithubId.setValue(githubId)
                return .stub1
            }
        } operation: {
            CardDetailService()
        }

        _ = try await service.removeCardFromMyDeck(githubId: expectedGithubId)

        #expect(receivedGithubId.value == expectedGithubId)
    }
}
