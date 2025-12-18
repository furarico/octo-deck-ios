//
//  SettingService.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Dependencies
import Foundation

final actor SettingService {
    @Dependency(\.gitHubAuthRepository) private var gitHubAuthRepository

    func signOut() async throws -> String {
        try await gitHubAuthRepository.signOut()
    }
}
