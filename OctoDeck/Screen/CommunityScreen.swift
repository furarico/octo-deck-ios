//
//  CommunityScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import SwiftUI

struct CommunityScreen: View {
    @State private var selectedCommunity: Community?
    @Binding private var community: Community?

    init(community: Binding<Community?>) {
        self._community = community
    }

    var body: some View {
        NavigationSplitView {
            CommunityListScreen(selectedCommunity: $selectedCommunity)
                .navigationTitle("Communities")
        } detail: {
            if let selectedCommunity {
                CommunityDetailScreen(community: selectedCommunity)
            }
        }
        .onChange(of: community) {
            if let community {
                selectedCommunity = community
                self.community = nil
            }
        }
    }
}

#Preview {
    CommunityScreen(community: .constant(nil))
}
