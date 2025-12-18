//
//  ContentServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Dependencies
import Foundation
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

    @Test("SignInURLが正しく返却される")
    func testGetSignInURLSuccess() async throws {
        let expected = URL(string: "https://github.com/login/oauth/authorize")!

        let service = withDependencies {
            $0.gitHubAuthRepository.getSignInURL = {
                expected
            }
        } operation: {
            ContentService()
        }

        #expect(try await service.getSignInURL() == expected)
    }

    @Test("SignInURLが返却されない")
    func testGetSignInURLFailure() async throws {
        let service = withDependencies {
            $0.gitHubAuthRepository.getSignInURL = {
                throw GitHubAuthRepositoryError.failedToLoadSignInURL
            }
        } operation: {
            ContentService()
        }

        await #expect(throws: GitHubAuthRepositoryError.self) {
            try await service.getSignInURL()
        }
    }

    @Test("AuthenticatedUserが正しく返却される")
    func testGetAuthenticatedUserSuccess() async throws {
        let expected = User.stub0

        let service = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                expected
            }
        } operation: {
            ContentService()
        }

        #expect(try await service.getAuthenticatedUser() == expected)
    }

    @Test("AuthenticatedUserが返却されない")
    func testGetAuthenticatedUserFailure() async throws {
        let service = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                throw GitHubAuthRepositoryError.userIdNotFound
            }
        } operation: {
            ContentService()
        }

        await #expect(throws: GitHubAuthRepositoryError.self) {
            try await service.getAuthenticatedUser()
        }
    }

    @Test("Cardが正しく返却される")
    func testGetCardSuccess() async throws {
        let expected = Card.stub0

        let service = withDependencies {
            $0.cardRepository.getCard = { _ in
                expected
            }
        } operation: {
            ContentService()
        }

        #expect(try await service.getCard(id: "51151242") == expected)
    }

    @Test("Cardが返却されない")
    func testGetCardFailure() async throws {
        let service = withDependencies {
            $0.cardRepository.getCard = { _ in
                throw CardRepositoryError.apiError(404, nil)
            }
        } operation: {
            ContentService()
        }

        await #expect(throws: CardRepositoryError.self) {
            try await service.getCard(id: "invalid-id")
        }
    }
}
