//
//  MyDeckViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Observation

@Observable
final class MyDeckViewModel {
    private(set) var myCard: Card?
    private(set) var cardsInMyDeck: [Card]
    private(set) var isLoading: Bool = false

    private let service = MyDeckService()

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            async let myCardTask = service.getMyCard()
            async let cardsInMyDeckTask = service.getCardsInMyDeck()
            (myCard, cardsInMyDeck) = try await (myCardTask, cardsInMyDeckTask)
        } catch {
            print(error)
        }
    }
}
