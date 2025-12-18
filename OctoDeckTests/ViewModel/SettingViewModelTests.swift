//
//  SettingViewModelTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct SettingViewModelTests {
    @Test("onSignOutButtonTappedでサインアウトが成功する")
    func testOnSignOutButtonTappedSuccess() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signOut = {
                "user1234"
            }
        } operation: {
            SettingViewModel()
        }

        await viewModel.onSignOutButtonTapped()
    }

    @Test("onSignOutButtonTappedでエラーが発生しても例外をスローしない")
    func testOnSignOutButtonTappedFailure() async throws {
        let viewModel = withDependencies {
            $0.gitHubAuthRepository.signOut = {
                throw GitHubAuthRepositoryError.userIdNotFound
            }
        } operation: {
            SettingViewModel()
        }

        await viewModel.onSignOutButtonTapped()
    }
}

