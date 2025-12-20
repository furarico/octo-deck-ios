//
//  SettingViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
final class SettingViewModel {
    private let service = SettingService()

    func onSignOutButtonTapped() async {
        do {
            let userID = try await service.signOut()
            print("Signed out from \(userID)")
        } catch {
            print(error)
        }
    }
}
