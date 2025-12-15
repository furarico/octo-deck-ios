//
//  CardView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/15.
//

import NukeUI
import SwiftUI

struct CardView: View {
    let card: Card
    var body: some View {
        imageCard
        HStack {
            image
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                }

            contentView
        }
    }

    private var imageCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))

        }
        .frame(width: 356, height: 224)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(card.userName)
                .font(.body)
                .bold()
                .lineLimit(1)
                .multilineTextAlignment(.leading)

            Text(card.fullName)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }

    private var image: some View {
        LazyImage(url: card.iconUrl) { state in
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
        Image("default")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    CardView(card: .stub0)
        .padding()
}
