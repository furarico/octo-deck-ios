//
//  CommunityScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import SwiftUI

struct CommunityScreen: View {
    @State private var selectedCommunity: Community?

    var body: some View {
        NavigationSplitView {
            CommunityListScreen(selectedCommunity: $selectedCommunity)
                .navigationTitle("Communities")
        } detail: {
            if let selectedCommunity {
                CommunityDetailScreen(community: selectedCommunity)
            }
        }
    }
}

#Preview {
    CommunityScreen()
}
