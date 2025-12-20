//
//  ContentViewModelTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct ContentViewModelTests {
    // MARK: - 初期状態

    @Test("初期状態が正しい")
    func testInitialState() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
            $0.gitHubAuthRepository.getSignInURL = {
                URL(string: "https://github.com/login/oauth/authorize")!
            }
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.cardRepository.getCard = { _ in
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        #expect(viewModel.safariViewURL == nil)
        #expect(viewModel.card == nil)
        #expect(viewModel.authenticatedUser == nil)
        #expect(viewModel.isLoading == false)
    }

    // MARK: - onAppear

    @Test("onAppearでauthenticatedUserが正しく取得される")
    func testOnAppearSuccess() async throws {
        let expectedUser = User.stub0

        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                expectedUser
            }
        } operation: {
            ContentViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.authenticatedUser == expectedUser)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでauthenticatedUserの取得に失敗した場合、nilのまま")
    func testOnAppearFailure() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                throw GitHubAuthRepositoryError.userIdNotFound
            }
        } operation: {
            ContentViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.authenticatedUser == nil)
        #expect(viewModel.isLoading == false)
    }

    // MARK: - refresh

    @Test("refreshでauthenticatedUserが正しく更新される")
    func testRefreshSuccess() async throws {
        let expectedUser = User.stub0

        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                expectedUser
            }
        } operation: {
            ContentViewModel()
        }

        #expect(viewModel.authenticatedUser == nil)

        await viewModel.refresh()

        #expect(viewModel.authenticatedUser == expectedUser)
    }

    @Test("refreshでauthenticatedUserの取得に失敗した場合、nilのまま")
    func testRefreshFailure() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                throw GitHubAuthRepositoryError.userIdNotFound
            }
        } operation: {
            ContentViewModel()
        }

        await viewModel.refresh()

        #expect(viewModel.authenticatedUser == nil)
    }

    // MARK: - onSignInButtonTapped

    @Test("onSignInButtonTappedでsafariViewURLが設定される")
    func testOnSignInButtonTappedSuccess() async throws {
        let expectedURL = URL(string: "https://github.com/login/oauth/authorize?client_id=test")!

        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getSignInURL = {
                expectedURL
            }
        } operation: {
            ContentViewModel()
        }

        #expect(viewModel.safariViewURL == nil)

        await viewModel.onSignInButtonTapped()

        #expect(viewModel.safariViewURL?.url == expectedURL)
    }

    @Test("onSignInButtonTappedでSignInURLの取得に失敗した場合、safariViewURLがnilのまま")
    func testOnSignInButtonTappedFailure() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getSignInURL = {
                throw GitHubAuthRepositoryError.failedToLoadSignInURL
            }
        } operation: {
            ContentViewModel()
        }

        await viewModel.onSignInButtonTapped()

        #expect(viewModel.safariViewURL == nil)
    }

    // MARK: - onSignOutButtonTapped

    @Test("onSignOutButtonTappedでauthenticatedUserがnilになる")
    func testOnSignOutButtonTapped() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        await viewModel.onAppear()
        #expect(viewModel.authenticatedUser != nil)

        viewModel.onSignOutButtonTapped()

        #expect(viewModel.authenticatedUser == nil)
    }

    // MARK: - handleURL

    @Test("handleURLでhttps以外のスキームは無視される")
    func testHandleURLIgnoresNonHttpsScheme() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "http://octodeck.furari.co/app/github/oauth/callback?code=test")!
        await viewModel.handleURL(url)

        #expect(viewModel.authenticatedUser == nil)
    }

    @Test("handleURLで異なるホストは無視される")
    func testHandleURLIgnoresDifferentHost() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://example.com/app/github/oauth/callback?code=test")!
        await viewModel.handleURL(url)

        #expect(viewModel.authenticatedUser == nil)
    }

    @Test("handleURLでOAuthコールバックが正しく処理される")
    func testHandleURLOAuthCallbackSuccess() async throws {
        let expectedUser = User.stub0

        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                expectedUser
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://octodeck.furari.co/app/github/oauth/callback?code=test_code")!
        await viewModel.handleURL(url)

        #expect(viewModel.authenticatedUser == expectedUser)
        #expect(viewModel.safariViewURL == nil)
    }

    @Test("handleURLでOAuthコールバックにcodeがない場合は無視される")
    func testHandleURLOAuthCallbackWithoutCode() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://octodeck.furari.co/app/github/oauth/callback")!
        await viewModel.handleURL(url)

        #expect(viewModel.authenticatedUser == nil)
    }

    @Test("handleURLでOAuthコールバックのサインインに失敗した場合")
    func testHandleURLOAuthCallbackSignInFailure() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                throw GitHubAuthRepositoryError.invalidResponse
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://octodeck.furari.co/app/github/oauth/callback?code=test_code")!
        await viewModel.handleURL(url)

        #expect(viewModel.authenticatedUser == nil)
    }

    @Test("handleURLでユーザーURLが正しく処理される")
    func testHandleURLUserPathSuccess() async throws {
        let expectedCard = Card.stub0

        let viewModel = withDependencies {
            $0.cardRepository.getCard = { _ in
                expectedCard
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://octodeck.furari.co/users/51151242")!
        await viewModel.handleURL(url)

        #expect(viewModel.card == expectedCard)
    }

    @Test("handleURLでユーザーURLのカード取得に失敗した場合")
    func testHandleURLUserPathFailure() async throws {
        let viewModel = withDependencies {
            $0.cardRepository.getCard = { _ in
                throw CardRepositoryError.apiError(404)
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://octodeck.furari.co/users/invalid-id")!
        await viewModel.handleURL(url)

        #expect(viewModel.card == nil)
    }

    @Test("handleURLで不明なパスは無視される")
    func testHandleURLUnknownPath() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
            $0.cardRepository.getCard = { _ in
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        let url = URL(string: "https://octodeck.furari.co/unknown/path")!
        await viewModel.handleURL(url)

        #expect(viewModel.authenticatedUser == nil)
        #expect(viewModel.card == nil)
    }

    @Test("handleURLでsafariViewURLがnilにリセットされる")
    func testHandleURLResetsSafariViewURL() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.getSignInURL = {
                URL(string: "https://github.com/login/oauth/authorize")!
            }
            $0.gitHubAuthRepository.signIn = { _ in
                "user1234"
            }
            $0.gitHubAuthRepository.getAuthenticatedUser = {
                .stub0
            }
        } operation: {
            ContentViewModel()
        }

        await viewModel.onSignInButtonTapped()
        #expect(viewModel.safariViewURL != nil)

        let url = URL(string: "https://octodeck.furari.co/app/github/oauth/callback?code=test")!
        await viewModel.handleURL(url)

        #expect(viewModel.safariViewURL == nil)
    }
}

