//
//  StatisticView.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import SwiftUI

struct StatisticView: View {
    let statistic: Statistic

    var body: some View {
        VStack(alignment: .leading) {
            Text("Contributions")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)

            ScrollView(.horizontal) {
                contributions
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var contributions: some View {
        let maxContributionCount = statistic.maxContributionCount()
        return HStack(alignment: .top, spacing: 4) {
            ForEach(0...(statistic.contributions.count / 7), id: \.self) { week in
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(0..<7, id: \.self) { dayOfWeek in
                        cell(week: week, dayOfWeek: dayOfWeek, maxContributionCount: maxContributionCount)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func cell(week: Int, dayOfWeek: Int, maxContributionCount: Int) -> some View {
        let index = 7 * week + dayOfWeek
        if index >= statistic.contributions.count {
            EmptyView()
        } else {
            let contributionRate = CGFloat(statistic.contributions[index].count) / CGFloat(maxContributionCount)
            RoundedRectangle(cornerRadius: 2)
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color(uiColor: .init(red: 1, green: 1, blue: 0.87, alpha: 1)),
                                Color(uiColor: .init(red: 0.87, green: 0.85, blue: 0.33, alpha: 1.0))
                            ]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 12, height: 12)
                .opacity(0.2 + 0.8 * contributionRate)
        }
    }
}

#Preview {
    ScrollView {
        StatisticView(statistic: .stub)
            .padding()
    }
}
