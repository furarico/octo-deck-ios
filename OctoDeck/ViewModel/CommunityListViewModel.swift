//
//  CommunityListViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Observation

@Observable
@MainActor
final class CommunityListViewModel {
    private(set) var communities: [Community] = []
    private(set) var isLoading: Bool = false

    private let service = CommunityListService()

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            communities = try await service.listCommunities()
        } catch {
            print(error)
        }
    }
}
