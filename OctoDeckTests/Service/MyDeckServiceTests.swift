//
//  MyDeckServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct MyDeckServiceTests {
    @Test("MyCardが正しく返却される")
    func testGetMyCardSuccess() async throws {
        let expected = Card.stub0

        let service = withDependencies {
            $0.cardRepository.getMyCard = {
                expected
            }
        } operation: {
            MyDeckService()
        }

        #expect(try await service.getMyCard() == expected)
    }

    @Test("MyCardが返却されない")
    func testGetMyCardFailure() async throws {
        let service = withDependencies {
            $0.cardRepository.getMyCard = {
                throw CardRepositoryError.apiError(500, nil)
            }
        } operation: {
            MyDeckService()
        }

        await #expect(throws: CardRepositoryError.self) {
            try await service.getMyCard()
        }
    }

    @Test("CardsInMyDeckが正しく返却される")
    func testGetCardsInMyDeckSuccess() async throws {
        let expected = Card.stubs

        let service = withDependencies {
            $0.cardRepository.listCards = {
                expected
            }
        } operation: {
            MyDeckService()
        }

        #expect(try await service.getCardsInMyDeck() == expected)
    }

    @Test("CardsInMyDeckが空配列で返却される")
    func testGetCardsInMyDeckEmpty() async throws {
        let expected: [Card] = []

        let service = withDependencies {
            $0.cardRepository.listCards = {
                expected
            }
        } operation: {
            MyDeckService()
        }

        #expect(try await service.getCardsInMyDeck() == expected)
    }

    @Test("CardsInMyDeckが返却されない")
    func testGetCardsInMyDeckFailure() async throws {
        let service = withDependencies {
            $0.cardRepository.listCards = {
                throw CardRepositoryError.apiError(500, nil)
            }
        } operation: {
            MyDeckService()
        }

        await #expect(throws: CardRepositoryError.self) {
            try await service.getCardsInMyDeck()
        }
    }
}

