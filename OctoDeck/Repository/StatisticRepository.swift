//
//  StatisticRepository.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies
import DependenciesMacros
import Foundation
import OpenAPIRuntime

@DependencyClient
nonisolated struct StatisticRepository {
    var getMyStats: @Sendable () async throws -> Statistic
    var getUserStats: @Sendable (_ githubId: String) async throws -> Statistic
}

nonisolated extension StatisticRepository: DependencyKey {
    static let liveValue = StatisticRepository(
        getMyStats: {
            let client = try await Client.build()
            let response = try await client.getMyStats()
            switch response {
            case .ok(let okResponse):
                let responseStats = try okResponse.body.json.stats
                return makeStatistic(from: responseStats)

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw StatisticRepositoryError.apiError(statusCode)
            }
        },
        getUserStats: { githubId in
            let client = try await Client.build()
            let response = try await client.getUserStats(path: .init(githubId: githubId))
            switch response {
            case .ok(let okResponse):
                let responseStats = try okResponse.body.json.stats
                return makeStatistic(from: responseStats)

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw StatisticRepositoryError.apiError(statusCode)
            }
        }
    )
}

nonisolated private extension StatisticRepository {
    static func makeStatistic(from responseStats: Components.Schemas.UserStats) -> Statistic {
        Statistic(
            contributions: responseStats.contributions.compactMap { contribution in
                guard let date = dateFormatter.date(from: contribution.date) else {
                    return nil
                }
                return Contribution(date: date, count: Int(contribution.count))
            },
            totalContribution: Int(responseStats.totalContribution),
            mostUsedLanguage: Language(
                name: responseStats.mostUsedLanguage.name,
                color: DomainColor(hexCode: responseStats.mostUsedLanguage.color)
            ),
            contributionDetail: ContributionDetail(
                reviewCount: Int(responseStats.contributionDetail.reviewCount),
                commitCount: Int(responseStats.contributionDetail.commitCount),
                pullRequestCount: Int(responseStats.contributionDetail.pullRequestCount),
                issueCount: Int(responseStats.contributionDetail.issueCount)
            )
        )
    }

    nonisolated(unsafe) static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
}

nonisolated extension StatisticRepository: TestDependencyKey {
    static let previewValue = StatisticRepository(
        getMyStats: {
            .stub
        },
        getUserStats: { _ in
            .stub
        }
    )
}

nonisolated extension DependencyValues {
    var statisticRepository: StatisticRepository {
        get { self[StatisticRepository.self] }
        set { self[StatisticRepository.self] = newValue }
    }
}
