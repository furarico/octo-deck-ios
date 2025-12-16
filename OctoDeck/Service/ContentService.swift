//
//  ContentService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies

final class ContentService {
    @Dependency(\.gitHubAuthRepository) private var gitHubAuthRepository

    func signIn(code: String) async throws -> String {
        try await gitHubAuthRepository.signIn(code: code)
    }

    func signOut() async throws -> String {
        try await gitHubAuthRepository.signOut()
    }

    func getAccessToken() async throws -> String {
        try await gitHubAuthRepository.getAccessToken()
    }
}
