//
//  CommunityRepository.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import DependenciesMacros
import Foundation
import OpenAPIRuntime

@DependencyClient
nonisolated struct CommunityRepository {
    var listCommunities: @Sendable () async throws -> [Community]
    var getCommunity: @Sendable (_ id: Community.ID) async throws -> (Community, HighlightedCard)
    var createCommunity: @Sendable (_ name: String) async throws -> Community
    var deleteCommunity: @Sendable (_ id: Community.ID) async throws -> Community
    var getCommunityCards: @Sendable (_ id: Community.ID) async throws -> [Card]
    var addCardToCommunity: @Sendable (_ id: Community.ID) async throws -> Card
    var removeCardFromCommunity: @Sendable (_ id: Community.ID) async throws -> Card
}

nonisolated extension CommunityRepository: DependencyKey {
    static let liveValue = CommunityRepository(
        listCommunities: {
            let client = try await Client.build()
            let response = try await client.getCommunities()
            switch response {
            case .ok(let okResponse):
                let responseCommunities = try okResponse.body.json.communities
                return responseCommunities.map {
                    Community(
                        id: $0.id,
                        name: $0.name
                    )
                }

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        },
        getCommunity: { id in
            let client = try await Client.build()
            let response = try await client.getCommunity(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                let json = try okResponse.body.json
                let responseCommunity = json.community
                let responseHighlightedCard = json.highlightedCard
                let community = Community(
                    id: responseCommunity.id,
                    name: responseCommunity.name
                )
                let highlightedCard = HighlightedCard(
                    bestReviewer: makeCard(from: responseHighlightedCard.bestReviewer),
                    bestContributor: makeCard(from: responseHighlightedCard.bestContributor),
                    bestCommitter: makeCard(from: responseHighlightedCard.bestCommitter),
                    bestPullRequester: makeCard(from: responseHighlightedCard.bestPullRequester),
                    bestIssuer: makeCard(from: responseHighlightedCard.bestIssuer)
                )
                return (community, highlightedCard)

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        },
        createCommunity: { name in
            let client = try await Client.build()
            let response = try await client.createCommunity(body: .plainText(.init(stringLiteral: name)))
            switch response {
            case .ok(let okResponse):
                let responseCommunity = try okResponse.body.json.community
                return Community(
                    id: responseCommunity.id,
                    name: responseCommunity.name
                )

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        },
        deleteCommunity: { id in
            let client = try await Client.build()
            let response = try await client.deleteCommunity(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                let responseCommunity = try okResponse.body.json.community
                return Community(
                    id: responseCommunity.id,
                    name: responseCommunity.name
                )

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        },
        getCommunityCards: { id in
            let client = try await Client.build()
            let response = try await client.getCommunityCards(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                let responseCards = try okResponse.body.json.cards
                return responseCards.map { makeCard(from: $0) }

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        },
        addCardToCommunity: { id in
            let client = try await Client.build()
            let response = try await client.addCardToCommunity(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return makeCard(from: responseCard)

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        },
        removeCardFromCommunity: { id in
            let client = try await Client.build()
            let response = try await client.removeCardFromCommunity(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                let responseCard = try okResponse.body.json.card
                return makeCard(from: responseCard)

            case .undocumented(let statusCode, let payload):
                print("API Error: \(statusCode), \(payload.body, default: "")")
                throw CommunityRepositoryError.apiError(statusCode, payload)
            }
        }
    )
}

nonisolated extension CommunityRepository: TestDependencyKey {
    static let previewValue = CommunityRepository(
        listCommunities: {
            Community.stubs
        },
        getCommunity: { _ in
            (.stub0, .stub0)
        },
        createCommunity: { name in
            Community(id: "new-community", name: name)
        },
        deleteCommunity: { _ in
            .stub0
        },
        getCommunityCards: { _ in
            Card.stubs
        },
        addCardToCommunity: { _ in
            .stub0
        },
        removeCardFromCommunity: { _ in
            .stub0
        }
    )
}

nonisolated extension DependencyValues {
    var communityRepository: CommunityRepository {
        get { self[CommunityRepository.self] }
        set { self[CommunityRepository.self] = newValue }
    }
}

nonisolated extension CommunityRepository {
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
