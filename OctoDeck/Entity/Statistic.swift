//
//  Statistic.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Foundation

struct Statistic: Equatable {
    let contributions: [Contribution]
    let totalContribution: Int
    let mostUsedLanguage: Language
    let contributionDetail: ContributionDetail

    func maxContributionCount() -> Int {
        contributions.map { $0.count }.max() ?? 0
    }
}

extension Statistic {
    static let stub: Statistic = {
        let calendar = Calendar.current
        let today = Date()
        let contributions = (0..<365).compactMap { dayOffset -> Contribution? in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else {
                return nil
            }
            let count = Int.random(in: 0...15)
            return Contribution(date: date, count: count)
        }.reversed()
        return Statistic(
            contributions: Array(contributions),
            totalContribution: contributions.reduce(0) { $0 + $1.count },
            mostUsedLanguage: .stub0,
            contributionDetail: .stub0
        )
    }()
}
