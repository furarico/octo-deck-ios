//
//  ContentService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies
import Foundation

final actor ContentService {
    @Dependency(\.cardRepository) private var cardRepository
    @Dependency(\.communityRepository) private var communityRepository
    @Dependency(\.gitHubAuthRepository) private var gitHubAuthRepository

    func signIn(code: String) async throws -> String {
        try await gitHubAuthRepository.signIn(code: code)
    }

    func getSignInURL() async throws -> URL {
        try await gitHubAuthRepository.getSignInURL()
    }

    func getAuthenticatedUser() async throws -> User {
        try await gitHubAuthRepository.getAuthenticatedUser()
    }

    func getCard(id: String) async throws -> Card {
        try await cardRepository.getCard(id: id)
    }

    func getCommunity(id: String) async throws -> Community {
        let (community, _) = try await communityRepository.getCommunity(id)
        return community
    }
}
