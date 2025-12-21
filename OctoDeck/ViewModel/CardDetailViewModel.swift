//
//  CardDetailViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Observation

@Observable
@MainActor
final class CardDetailViewModel {
    let card: Card
    private(set) var statistic: Statistic?
    private(set) var isLoading: Bool = false
    private(set) var isDeckStatusLoading: Bool = false

    private let service = CardDetailService()

    init(card: Card) {
        self.card = card
    }

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }
        await refresh()
    }

    private func refresh() async {
        do {
            statistic = try await service.getStatistic(of: card.id)
        } catch {
            print(error)
        }
    }

    func onAddButtonTapped(isAdding: Bool) async {
        isDeckStatusLoading = true
        defer {
            isDeckStatusLoading = false
        }

        do {
            if isAdding {
                _ = try await service.addCardToMyDeck(githubId: card.id)
            } else {
                _ = try await service.removeCardFromMyDeck(githubId: card.id)
            }
        } catch {
            print(error)
        }
    }
}
