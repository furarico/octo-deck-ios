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
    }

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let user = viewModel.authenticatedUser {
            VStack {
                Text("Hi! \(user.fullName).")

                Button("Sign Out") {
                    Task {
                        await viewModel.onSignOutButtonTapped()
                    }
                }
            }
        } else {
            Button("Sign In with GitHub") {
                Task {
                    await viewModel.onSignInButtonTapped()
                }
            }
        }
    }
}

#Preview {
    ContentScreen()
}
