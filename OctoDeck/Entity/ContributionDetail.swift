//
//  ContributionDetail.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/19.
//

struct ContributionDetail: Equatable {
    let reviewCount: Int
    let commitCount: Int
    let pullRequestCount: Int
    let issueCount: Int
}

extension ContributionDetail {
    static let stub0 = ContributionDetail(
        reviewCount: 12,
        commitCount: 240,
        pullRequestCount: 18,
        issueCount: 6
    )
}
