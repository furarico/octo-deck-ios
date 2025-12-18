//
//  CommunityListScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import SwiftUI

struct CommunityListScreen: View {
    @State private var viewModel = CommunityListViewModel()

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
    }

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.communities.isEmpty {
            ContentUnavailableView(
                "No Communities",
                systemImage: "person.3",
                description: Text("Communities you join will appear here.")
            )
        } else {
            List(viewModel.communities) { community in
                NavigationLink(value: community) {
                    Text(community.name)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommunityListScreen()
    }
}
