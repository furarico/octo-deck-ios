//
//  CardDetailViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Observation

@Observable
final class CardDetailViewModel {
    let card: Card
    private(set) var statistic: Statistic?
    private(set) var isLoading: Bool = false

    private let service = CardDetailService()

    init(card: Card) {
        self.card = card
    }

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            statistic = try await service.getStatistic(of: card.id)
        } catch {
            print(error)
        }
    }
}

