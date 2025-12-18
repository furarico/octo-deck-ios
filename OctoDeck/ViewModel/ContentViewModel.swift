//
//  ContentViewModel.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class ContentViewModel {
    var safariViewURL: IdentifiableURL? = nil
    var card: Card? = nil
    private(set) var authenticatedUser: User? = nil
    private(set) var isLoading: Bool = false

    private let service = ContentService()

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }

        await refresh()
    }

    func refresh() async {
        do {
            authenticatedUser = try await service.getAuthenticatedUser()
        } catch {
            print(error)
        }
    }

    func onSignInButtonTapped() async {
        do {
            let url = try await service.getSignInURL()
            safariViewURL = IdentifiableURL(url: url)
        } catch {
            print(error)
            return
        }
    }

    func onSignOutButtonTapped() async {
        do {
            let userID = try await service.signOut()
            print("Signed out from \(userID)")
        } catch {
            print(error)
        }
        
        authenticatedUser = nil
    }

    func handleURL(_ url: URL) async {
        safariViewURL = nil

        guard url.scheme == "https" else {
            return
        }
        guard url.host() == "octodeck.furari.co" else {
            return
        }

        let path = url.pathComponents
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        if path == ["/", "app", "github", "oauth", "callback"] {
            guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
                return
            }
            do {
                let userID = try await service.signIn(code: code)
                print("Signed in as \(userID)")

                isLoading = true
                defer {
                    isLoading = false
                }

                await refresh()
            } catch {
                print(error)
                return
            }
        } else if path.count == 3 && path.prefix(2) == ["/", "users"] {
            let userId = path[2]
            do {
                card = try await service.getCard(id: userId)
            } catch {
                print(error)
                return
            }
        } else {
            return
        }
    }
}
