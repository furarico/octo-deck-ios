//
//  ContentServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies
import Testing
@testable import OctoDeck

@MainActor
struct ContentServiceTests {
    @Test("SignInが正しく終了する")
    func testSignInSuccess() async throws {
        let expected = "user1234"

        let service = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                expected
            }
        } operation: {
            ContentService()
        }

        #expect(try await service.signIn(code: "") == expected)
    }

    @Test("SignInがエラーをthrowする")
    func testSignInFailure() async throws {
        let service = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                throw GitHubAuthRepositoryError.missingConfiguration
            }
        } operation: {
            ContentService()
        }

        await #expect(throws: GitHubAuthRepositoryError.self) {
            try await service.signIn(code: "")
        }
    }

    @Test("SignOutが正しく終了する")
    func testSignOutSuccess() async throws {
        let expected = "user1234"

        let service = withDependencies {
            $0.gitHubAuthRepository.signOut = {
                expected
            }
        } operation: {
            ContentService()
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
            ContentService()
        }

        await #expect(throws: GitHubAuthRepositoryError.self) {
            try await service.signOut()
        }
    }

    @Test("AccessTokenが正しく返却される")
    func testGetAccessTokenSuccess() async throws {
        let expected = "access-token-1234"

        let service = withDependencies {
            $0.gitHubAuthRepository.getAccessToken = {
                expected
            }
        } operation: {
            ContentService()
        }

        #expect(try await service.getAccessToken() == expected)
    }

    @Test("AccessTokenが返却されない")
    func testGetAccessTokenFailure() async throws {
        let service = withDependencies {
            $0.gitHubAuthRepository.getAccessToken = {
                throw GitHubAuthRepositoryError.userIdNotFound
            }
        } operation: {
            ContentService()
        }

        await #expect(throws: GitHubAuthRepositoryError.self) {
            try await service.getAccessToken()
        }
    }
}
