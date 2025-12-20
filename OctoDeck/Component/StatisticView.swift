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
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Most Used Language")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.leading)

                mostUsedLanguage
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 16) {
                Text("Contributions")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                contributions
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var mostUsedLanguage: some View {
        HStack {
            Circle()
                .fill(
                    Color(domainColor: statistic.mostUsedLanguage.color)
                )
                .frame(width: 16, height: 16)
            Text(statistic.mostUsedLanguage.name)
                .bold()
        }
    }

    @ViewBuilder
    private var contributions: some View {
        let maxContributionCount = statistic.maxContributionCount()
        VStack(spacing: 24) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 4) {
                    ForEach(0...(statistic.contributions.count / 7), id: \.self) { week in
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(0..<7, id: \.self) { dayOfWeek in
                                cell(week: week, dayOfWeek: dayOfWeek, maxContributionCount: maxContributionCount)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Total Contributions")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(statistic.totalContribution.description)
                        .font(.title3)
                        .bold()
                }

                HStack {
                    Text("Commit")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(statistic.contributionDetail.commitCount.description)
                        .font(.title3)
                        .bold()
                }

                HStack {
                    Text("Review")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(statistic.contributionDetail.reviewCount.description)
                        .font(.title3)
                        .bold()
                }

                HStack {
                    Text("Issue")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(statistic.contributionDetail.issueCount.description)
                        .font(.title3)
                        .bold()
                }

                HStack {
                    Text("Pull Request")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(statistic.contributionDetail.pullRequestCount.description)
                        .font(.title3)
                        .bold()
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func cell(week: Int, dayOfWeek: Int, maxContributionCount: Int) -> some View {
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
                                Color(red: 1, green: 1, blue: 0.87),
                                Color(red: 0.87, green: 0.85, blue: 0.33)
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
    }
}
