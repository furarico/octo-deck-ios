//
//  CommunityListViewModelTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct CommunityListViewModelTests {
    // MARK: - 初期状態

    @Test("初期状態が正しい")
    func testInitialState() async throws {
        let viewModel = withDependencies {
            $0.communityRepository.listCommunities = {
                Community.stubs
            }
        } operation: {
            CommunityListViewModel()
        }

        #expect(viewModel.communities == [])
        #expect(viewModel.isLoading == false)
    }

    // MARK: - onAppear

    @Test("onAppearでcommunitiesが正しく取得される")
    func testOnAppearSuccess() async throws {
        let expectedCommunities = Community.stubs

        let viewModel = withDependencies {
            $0.communityRepository.listCommunities = {
                expectedCommunities
            }
        } operation: {
            CommunityListViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.communities == expectedCommunities)
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearでcommunitiesの取得に失敗した場合、空配列のまま")
    func testOnAppearFailure() async throws {
        let viewModel = withDependencies {
            $0.communityRepository.listCommunities = {
                throw CommunityRepositoryError.apiError(500, nil)
            }
        } operation: {
            CommunityListViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.communities == [])
        #expect(viewModel.isLoading == false)
    }

    @Test("onAppearで空のcommunitiesが正しく取得される")
    func testOnAppearEmptyCommunities() async throws {
        let expectedCommunities: [Community] = []

        let viewModel = withDependencies {
            $0.communityRepository.listCommunities = {
                expectedCommunities
            }
        } operation: {
            CommunityListViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.communities == expectedCommunities)
        #expect(viewModel.isLoading == false)
    }
}
