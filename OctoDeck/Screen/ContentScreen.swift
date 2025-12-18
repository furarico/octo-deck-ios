//
//  ContentScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/14.
//

import SwiftUI

struct ContentScreen: View {
    @State private var viewModel = ContentViewModel()

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
            .sheet(item: $viewModel.safariViewURL) { item in
                SafariView(url: item.url)
            }
            .onOpenURL { url in
                Task {
                    await viewModel.handleURL(url)
                }
            }
            .preferredColorScheme(.dark)
    }

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let user = viewModel.authenticatedUser {
            tabView(user: user)
        } else {
            LoginView {
                Task {
                    await viewModel.onSignInButtonTapped()
                }
            }
        }
    }

    func tabView(user: User) -> some View {
        TabView {
            Tab("My Deck", systemImage: "person.crop.rectangle.stack") {
                MyDeckScreen(card: $viewModel.card)
            }

            Tab("Settings", systemImage: "gear") {
                SettingScreen(user: user) {
                    viewModel.onSignOutButtonTapped()
                }
            }
        }
    }
}

#Preview {
    ContentScreen()
}
