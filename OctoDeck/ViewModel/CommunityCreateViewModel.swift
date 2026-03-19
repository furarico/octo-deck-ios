//
//  CommunityCreateViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2026/03/19.
//

import Foundation
import Observation

@Observable
@MainActor
final class CommunityCreateViewModel {
    var name: String = ""
    var startAt: Date = .now
    var endAt: Date = Date.now.addingTimeInterval(3600)

    var isValid: Bool {
        !name.isEmpty && endAt > startAt
    }

    private(set) var isSubmitting: Bool = false
    private(set) var isCompleted: Bool = false

    private let service = CommunityCreateService()

    func onSubmit() async {
        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let community = try await service.createCommunity(name: name, startAt: startAt, endAt: endAt)
            try await service.joinCommunity(id: community.id)
            isCompleted = true
        } catch {
            print(error)
        }
    }
}
