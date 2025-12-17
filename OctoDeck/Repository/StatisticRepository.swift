//
//  StatisticRepository.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies
import DependenciesMacros
import Foundation

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
                return Statistic(
                    contributions: responseStats.contributions.compactMap { contribution in
                        guard let date = ISO8601DateFormatter.dateOnly.date(from: contribution.date) else {
                            return nil
                        }
                        return Contribution(date: date, count: Int(contribution.count))
                    }
                )
            default:
                throw StatisticRepositoryError.failedToFetchStats
            }
        },
        getUserStats: { githubId in
            let client = try await Client.build()
            let response = try await client.getUserStats(path: .init(githubId: githubId))
            switch response {
            case .ok(let okResponse):
                let responseStats = try okResponse.body.json.stats
                return Statistic(
                    contributions: responseStats.contributions.compactMap { contribution in
                        guard let date = ISO8601DateFormatter.dateOnly.date(from: contribution.date) else {
                            return nil
                        }
                        return Contribution(date: date, count: Int(contribution.count))
                    }
                )
            default:
                throw StatisticRepositoryError.failedToFetchStats
            }
        }
    )
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

private extension ISO8601DateFormatter {
    static let dateOnly: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
}
