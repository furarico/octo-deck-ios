//
//  ContentScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/14.
//

import SwiftUI

private enum ContentTab {
    case myDeck
    case community
    case settings
}

struct ContentScreen: View {
    @State private var viewModel = ContentViewModel()
    @State private var selectedTab: ContentTab = .myDeck

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
            .onChange(of: viewModel.community) {
                if viewModel.community != nil {
                    selectedTab = .community
                }
            }
            .preferredColorScheme(.dark)
    }

    @ViewBuilder
    var content: some View {
        if let user = viewModel.authenticatedUser {
            tabView(user: user)
        } else if viewModel.isLoading {
            ProgressView()
        } else {
            LoginView {
                Task {
                    await viewModel.onSignInButtonTapped()
                }
            }
        }
    }

    func tabView(user: User) -> some View {
        TabView(selection: $selectedTab) {
            Tab("My Deck", systemImage: "person.crop.rectangle.stack", value: ContentTab.myDeck) {
                MyDeckScreen(card: $viewModel.card)
            }

            Tab("Community", systemImage: "globe", value: ContentTab.community) {
                CommunityScreen(community: $viewModel.community)
            }

            Tab("Settings", systemImage: "gear", value: ContentTab.settings) {
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
