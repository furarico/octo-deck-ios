//
//  CardDetailService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies

final actor CardDetailService {
    @Dependency(\.statisticRepository) private var statisticRepository

    func getStatistic(of githubId: String) async throws -> Statistic {
        try await statisticRepository.getUserStats(githubId: githubId)
    }
}
