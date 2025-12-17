//
//  Statistic.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Foundation

struct Statistic: Equatable {
    let contributions: [Contribution]
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
        return Statistic(contributions: Array(contributions))
    }()
}
