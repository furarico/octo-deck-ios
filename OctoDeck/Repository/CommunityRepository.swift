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
    var getCommunity: @Sendable (_ id: Community.ID) async throws -> Community
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
            .stub0
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

