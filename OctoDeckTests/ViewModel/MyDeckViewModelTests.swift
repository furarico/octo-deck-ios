//
//  MyDeckViewModelTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct MyDeckViewModelTests {
    @Test("onAppearでMyCardとCardsInMyDeckが正しく取得される")
    func testOnAppearSuccess() async throws {
        let expectedMyCard = Card.stub0
        let expectedCardsInMyDeck = Card.stubs

        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                expectedMyCard
            }
            $0.cardRepository.listCards = {
                expectedCardsInMyDeck
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.myCard == expectedMyCard)
        #expect(viewModel.cardsInMyDeck == expectedCardsInMyDeck)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでMyCardの取得に失敗した場合、myCardがnilのまま")
    func testOnAppearMyCardFailure() async throws {
        let expectedCardsInMyDeck = Card.stubs

        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                throw CardRepositoryError.apiError(500)
            }
            $0.cardRepository.listCards = {
                expectedCardsInMyDeck
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.myCard == nil)
        #expect(viewModel.cardsInMyDeck == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでCardsInMyDeckの取得に失敗した場合、cardsInMyDeckが空配列のまま")
    func testOnAppearCardsInMyDeckFailure() async throws {
        let expectedMyCard = Card.stub0

        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                expectedMyCard
            }
            $0.cardRepository.listCards = {
                throw CardRepositoryError.apiError(500)
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.myCard == nil)
        #expect(viewModel.cardsInMyDeck == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでCardsInMyDeckが空配列の場合")
    func testOnAppearEmptyCardsInMyDeck() async throws {
        let expectedMyCard = Card.stub0
        let expectedCardsInMyDeck: [Card] = []

        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                expectedMyCard
            }
            $0.cardRepository.listCards = {
                expectedCardsInMyDeck
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.myCard == expectedMyCard)
        #expect(viewModel.cardsInMyDeck == expectedCardsInMyDeck)
        #expect(viewModel.isLoading == false)
    }

    @Test("初期状態が正しい")
    func testInitialState() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                Card.stubs
            }
        } operation: {
            MyDeckViewModel()
        }

        #expect(viewModel.myCard == nil)
        #expect(viewModel.cardsInMyDeck == [])
        #expect(viewModel.isLoading == false)
        #expect(viewModel.selectedCard == nil)
    }

    @Test("onCardSelectedでselectedCardが設定される")
    func testOnCardSelected() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                Card.stubs
            }
        } operation: {
            MyDeckViewModel()
        }

        #expect(viewModel.selectedCard == nil)

        viewModel.onCardSelected(Card.stub0)

        #expect(viewModel.selectedCard == Card.stub0)
    }

    @Test("onCardSelectedで別のカードを選択するとselectedCardが更新される")
    func testOnCardSelectedUpdatesSelection() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                Card.stubs
            }
        } operation: {
            MyDeckViewModel()
        }

        viewModel.onCardSelected(Card.stub0)
        #expect(viewModel.selectedCard == Card.stub0)

        viewModel.onCardSelected(Card.stub1)
        #expect(viewModel.selectedCard == Card.stub1)
    }

    // MARK: - onAddButtonTapped

    @Test("onAddButtonTappedでデッキにないカードが追加される")
    func testOnAddButtonTappedAddsCard() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()
        #expect(viewModel.cardsInMyDeck == [])

        viewModel.onAddButtonTapped(card: Card.stub1)

        #expect(viewModel.cardsInMyDeck.contains(Card.stub1))
        #expect(viewModel.cardsInMyDeck.count == 1)
    }

    @Test("onAddButtonTappedでデッキにあるカードが削除される")
    func testOnAddButtonTappedRemovesCard() async throws {
        let initialCards = [Card.stub0, Card.stub1]

        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                initialCards
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()
        #expect(viewModel.cardsInMyDeck == initialCards)

        viewModel.onAddButtonTapped(card: Card.stub1)

        #expect(!viewModel.cardsInMyDeck.contains(Card.stub1))
        #expect(viewModel.cardsInMyDeck.contains(Card.stub0))
        #expect(viewModel.cardsInMyDeck.count == 1)
    }

    @Test("onAddButtonTappedで同じカードを2回タップするとトグルされる")
    func testOnAddButtonTappedTogglesCard() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        // 追加
        viewModel.onAddButtonTapped(card: Card.stub1)
        #expect(viewModel.cardsInMyDeck.contains(Card.stub1))

        // 削除
        viewModel.onAddButtonTapped(card: Card.stub1)
        #expect(!viewModel.cardsInMyDeck.contains(Card.stub1))
    }

    @Test("onAddButtonTappedで複数のカードを追加できる")
    func testOnAddButtonTappedAddsMultipleCards() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                []
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        viewModel.onAddButtonTapped(card: Card.stub0)
        viewModel.onAddButtonTapped(card: Card.stub1)

        #expect(viewModel.cardsInMyDeck.contains(Card.stub0))
        #expect(viewModel.cardsInMyDeck.contains(Card.stub1))
        #expect(viewModel.cardsInMyDeck.count == 2)
    }

    @Test("onAddButtonTappedで削除しても他のカードに影響しない")
    func testOnAddButtonTappedRemovesOnlyTargetCard() async throws {
        let initialCards = [Card.stub0, Card.stub1]

        let viewModel = withDependencies {
            $0.cardRepository.getMyCard = {
                .stub0
            }
            $0.cardRepository.listCards = {
                initialCards
            }
        } operation: {
            MyDeckViewModel()
        }

        await viewModel.onAppear()

        viewModel.onAddButtonTapped(card: Card.stub0)

        #expect(!viewModel.cardsInMyDeck.contains(Card.stub0))
        #expect(viewModel.cardsInMyDeck.contains(Card.stub1))
        #expect(viewModel.cardsInMyDeck.count == 1)
    }
}
