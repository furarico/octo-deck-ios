//
//  CardRepository.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies
import DependenciesMacros
import Foundation
import OpenAPIRuntime

@DependencyClient
nonisolated struct CardRepository {
    var listCards: @Sendable () async throws -> [Card]
    var getCard: @Sendable (_ id: Card.ID) async throws -> Card
    var getMyCard: @Sendable () async throws -> Card
    var addCardToMyDeck: @Sendable (_ id: Card.ID) async throws -> Card
    var removeCardFromMyDeck: @Sendable (_ id: Card.ID) async throws -> Card
}

nonisolated extension CardRepository: DependencyKey {
    static let liveValue = CardRepository(
        listCards: {
            let client = try await Client.build()
            let response = try await client.getCards()
            switch response {
            case .ok(let okResponse):
                let responseCards = try okResponse.body.json.cards
                return responseCards.map { makeCard(from: $0) }

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw StatisticRepositoryError.apiError(statusCode)
            }
        },
        getCard: { id in
            let client = try await Client.build()
            let response = try await client.getCard(path: .init(githubId: id))
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return makeCard(from: responseCard)

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw StatisticRepositoryError.apiError(statusCode)
            }
        },
        getMyCard: {
            let client = try await Client.build()
            let response = try await client.getMyCard()
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return makeCard(from: responseCard)

            case .undocumented(let statusCode, let payload):
                throw StatisticRepositoryError.apiError(statusCode)
            }
        },
        addCardToMyDeck: { id in
            let client = try await Client.build()
            let response = try await client.addCardToDeck(body: .plainText(.init(stringLiteral: id)))
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return makeCard(from: responseCard)

            case .undocumented(let statusCode, let payload):
                throw StatisticRepositoryError.apiError(statusCode)
            }
        },
        removeCardFromMyDeck: { id in
            let client = try await Client.build()
            let response = try await client.removeCardFromDeck(path: .init(githubId: id))
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return makeCard(from: responseCard)

            case .undocumented(let statusCode, let payload):
                throw StatisticRepositoryError.apiError(statusCode)
            }
        }
    )
}

nonisolated extension CardRepository: TestDependencyKey {
    static let previewValue = CardRepository(
        listCards: {
            Card.stubs
        },
        getCard: { _ in
            .stub0
        },
        getMyCard: {
            .stub0
        },
        addCardToMyDeck: { _ in
            .stub1
        },
        removeCardFromMyDeck: { _ in
            .stub1
        }
    )
}

nonisolated extension DependencyValues {
    var cardRepository: CardRepository {
        get { self[CardRepository.self] }
        set { self[CardRepository.self] = newValue }
    }
}

nonisolated extension CardRepository {
    private static func makeCard(from response: Components.Schemas.Card) -> Card {
        Card(
            id: response.githubId,
            userName: response.userName,
            fullName: response.fullName,
            iconUrl: URL(string: response.iconUrl),
            identicon: Identicon(
                color: DomainColor(hexCode: response.identicon.color),
                blocks: response.identicon.blocks
            ),
            mostUsedLanguage: Language(
                name: response.mostUsedLanguage.name,
                color: DomainColor(hexCode: response.mostUsedLanguage.color)
            )
        )
    }
}
