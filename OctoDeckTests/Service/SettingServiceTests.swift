//
//  SettingServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct SettingServiceTests {
    @Test("SignOutが正しく終了する")
    func testSignOutSuccess() async throws {
        let expected = "user1234"

        let service = withDependencies {
            $0.gitHubAuthRepository.signOut = {
                expected
            }
        } operation: {
            SettingService()
        }

        #expect(try await service.signOut() == expected)
    }

    @Test("SignOutがエラーをthrowする")
    func testSignOutFailure() async throws {
        let service = withDependencies {
            $0.gitHubAuthRepository.signOut = {
                throw GitHubAuthRepositoryError.userIdNotFound
            }
        } operation: {
            SettingService()
        }

        await #expect(throws: GitHubAuthRepositoryError.self) {
            try await service.signOut()
        }
    }
}

