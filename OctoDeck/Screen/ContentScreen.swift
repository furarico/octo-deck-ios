//
//  ContentScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/14.
//

import SwiftUI

struct ContentScreen: View {
    @State private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel = ContentViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
            .fullScreenCover(item: $viewModel.safariViewURL) { item in
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
            Button("Sign In with GitHub") {
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

            Tab("Debug", systemImage: "info.circle") {
                VStack {
                    Text("Hi! \(user.fullName).")

                    Button("Sign Out") {
                        Task {
                            await viewModel.onSignOutButtonTapped()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentScreen()
}
