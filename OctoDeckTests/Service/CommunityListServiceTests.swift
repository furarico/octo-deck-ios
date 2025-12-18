//
//  CommunityListServiceTests.swift
//  OctoDeckTests
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct CommunityListServiceTests {
    @Test("Communityリストが正しく返却される")
    func testListCommunitiesSuccess() async throws {
        let expected = Community.stubs

        let service = withDependencies {
            $0.communityRepository.listCommunities = {
                expected
            }
        } operation: {
            CommunityListService()
        }

        #expect(try await service.listCommunities() == expected)
    }

    @Test("空のCommunityリストが正しく返却される")
    func testListCommunitiesEmpty() async throws {
        let expected: [Community] = []

        let service = withDependencies {
            $0.communityRepository.listCommunities = {
                expected
            }
        } operation: {
            CommunityListService()
        }

        #expect(try await service.listCommunities() == expected)
    }

    @Test("Communityリスト取得でエラーが発生する")
    func testListCommunitiesFailure() async throws {
        let service = withDependencies {
            $0.communityRepository.listCommunities = {
                throw CommunityRepositoryError.apiError(500, nil)
            }
        } operation: {
            CommunityListService()
        }

        await #expect(throws: CommunityRepositoryError.self) {
            try await service.listCommunities()
        }
    }
}

