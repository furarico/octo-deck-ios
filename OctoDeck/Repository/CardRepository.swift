//
//  CardRepository.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
nonisolated struct CardRepository {
    var listCards: @Sendable () async throws -> [Card]
    var getCard: @Sendable (_ id: Card.ID) async throws -> Card
    var getMyCard: @Sendable () async throws -> Card
}

nonisolated extension CardRepository: DependencyKey {
    static let liveValue = CardRepository(
        listCards: {
            let client = try await Client.build()
            let response = try await client.getCards()
            switch response {
            case .ok(let okResponse):
                let responseCards = try okResponse.body.json.cards
                return responseCards.map {
                    Card(
                        id: $0.githubId,
                        userName: $0.userName,
                        fullName: $0.fullName,
                        iconUrl: URL(string: $0.iconUrl),
                        identicon: Identicon(
                            color: DomainColor(hexCode: $0.identicon.color),
                            blocks: $0.identicon.blocks
                        )
                    )
                }
            default:
                throw CardRepositoryError.failedToFetchCards
            }
        },
        getCard: { id in
            let client = try await Client.build()
            let response = try await client.getCard(path: .init(githubId: id))
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return Card(
                    id: responseCard.githubId,
                    userName: responseCard.userName,
                    fullName: responseCard.fullName,
                    iconUrl: URL(string: responseCard.iconUrl),
                    identicon: Identicon(
                        color: DomainColor(hexCode: responseCard.identicon.color),
                        blocks: responseCard.identicon.blocks
                    )
                )
            default:
                throw CardRepositoryError.failedToFetchCards
            }
        },
        getMyCard: {
            let client = try await Client.build()
            let response = try await client.getMyCard()
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return Card(
                    id: responseCard.githubId,
                    userName: responseCard.userName,
                    fullName: responseCard.fullName,
                    iconUrl: URL(string: responseCard.iconUrl),
                    identicon: Identicon(
                        color: DomainColor(hexCode: responseCard.identicon.color),
                        blocks: responseCard.identicon.blocks
                    )
                )
            default:
                throw CardRepositoryError.failedToFetchCards
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
        }
    )
}

nonisolated extension DependencyValues {
    var cardRepository: CardRepository {
        get { self[CardRepository.self] }
        set { self[CardRepository.self] = newValue }
    }
}
