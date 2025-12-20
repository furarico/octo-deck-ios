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

            VStack(alignment: .leading, spacing: 8) {
                Text("Contributions")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                contributions
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
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
        VStack(spacing: 16) {
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
                .padding()
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
            let contributionRate = CGFloat(log(Double(statistic.contributions[index].count))) / CGFloat(log(Double(maxContributionCount)))
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
                .opacity(0.2 + 0.8 * (contributionRate < 0 ? 0 : contributionRate))
                .shadow(
                    color: Color(red: 255/255, green: 254/255, blue: 222/255),
                    radius: 8
                )
        }
    }
}

#Preview {
    ScrollView {
        StatisticView(statistic: .stub)
    }
}
