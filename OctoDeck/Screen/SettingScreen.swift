//
//  SettingScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import NukeUI
import SwiftUI

struct SettingScreen: View {
    private let user: User
    private let onSignOutButtonTapped: () -> Void
    @State private var viewModel = SettingViewModel()

    init(user: User, onSignOutButtonTapped: @escaping () -> Void) {
        self.user = user
        self.onSignOutButtonTapped = onSignOutButtonTapped
    }

    var body: some View {
        List {
            HStack {
                image
                    .frame(width: 50, height: 50)
                    .clipped()
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.fullName)
                        .font(.title3)
                        .bold()
                    HStack {
                        Text(user.userName)
                            .font(.callout)
                        Text("ID: \(user.id)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button("Sign Out", role: .destructive) {
                Task {
                    await viewModel.onSignOutButtonTapped()
                    onSignOutButtonTapped()
                }
            }
        }
    }

    private var image: some View {
        LazyImage(url: user.avatarUrl) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if state.error != nil {
                defaultImage
            } else {
                ProgressView()
            }
        }
    }

    private var defaultImage: some View {
        // TODO: 修正
        Image("default")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    SettingScreen(user: .stub0) {
    }
}
