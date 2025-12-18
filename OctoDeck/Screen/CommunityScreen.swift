//
//  CommunityScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

import SwiftUI

struct CommunityScreen: View {
    var body: some View {
        NavigationSplitView {
            CommunityListScreen()
                .navigationTitle("Communities")
        } detail: {
        }
    }
}

#Preview {
    CommunityScreen()
}
