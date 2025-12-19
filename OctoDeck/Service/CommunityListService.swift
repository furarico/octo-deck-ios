//
//  CommunityListService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies

final actor CommunityListService {
    @Dependency(\.communityRepository) private var communityRepository

    func listCommunities() async throws -> [Community] {
        try await communityRepository.listCommunities()
    }
}
