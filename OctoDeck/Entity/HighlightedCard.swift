//
//  HighlightedCard.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Foundation

struct HighlightedCard: Equatable {
    let bestReviewer: Card
    let bestContributor: Card
    let bestCommitter: Card
    let bestPullRequester: Card
    let bestIssuer: Card
}

extension HighlightedCard {
    static let stub0 = HighlightedCard(
        bestReviewer: .stub0,
        bestContributor: .stub1,
        bestCommitter: .stub0,
        bestPullRequester: .stub1,
        bestIssuer: .stub0
    )

    static let stubs = [stub0]
}

