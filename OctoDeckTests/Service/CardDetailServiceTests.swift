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
                throw StatisticRepositoryError.apiError(500, nil)
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
}
