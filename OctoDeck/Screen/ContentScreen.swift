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
        Button("Sign In with GitHub") {
            Task {
                await viewModel.onSignInButtonTapped()
            }
        }
        .padding()
        .sheet(item: $viewModel.safariViewURL) { item in
            SafariView(url: item.url)
        }
        .onOpenURL { url in
            Task {
                await viewModel.handleURL(url)
            }
        }
    }
}

#Preview {
    ContentScreen()
}
