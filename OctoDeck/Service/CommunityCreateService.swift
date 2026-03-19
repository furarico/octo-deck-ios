//
//  CommunityCreateService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2026/03/19.
//

import Dependencies
import Foundation

final actor CommunityCreateService {
    @Dependency(\.communityRepository) private var communityRepository

    func createCommunity(name: String, startAt: Date, endAt: Date) async throws -> Community {
        try await communityRepository.createCommunity(name: name, startAt: startAt, endAt: endAt)
    }

    func joinCommunity(id: Community.ID) async throws {
        _ = try await communityRepository.addCardToCommunity(id: id)
    }
}
