//
//  CommunityListScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import SwiftUI

struct CommunityListScreen: View {
    @State private var viewModel = CommunityListViewModel()
    @Binding private var selectedCommunity: Community?

    init(selectedCommunity: Binding<Community?>) {
        self._selectedCommunity = selectedCommunity
    }

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
    }

    @ViewBuilder
    var content: some View {
        if !viewModel.communities.isEmpty {
            List(viewModel.communities, selection: $selectedCommunity) { community in
                NavigationLink(community.name, value: community)
            }
            .refreshable {
                await viewModel.onRefresh()
            }
        } else if viewModel.isLoading {
            ProgressView()
        } else {
            ContentUnavailableView(
                "No Communities",
                systemImage: "globe",
                description: Text("Communities you join will appear here.")
            )
        }
    }
}

#Preview {
    CommunityListScreen(selectedCommunity: .constant(nil))
}
