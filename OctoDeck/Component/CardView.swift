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
            .overlay {
                HStack(spacing: 16) {
                    image
                        .frame(width: 80, height: 80)
                        .clipped()
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.secondary, lineWidth: 2)
                        }

                    textView

                    Spacer()
                }
                .padding(20)
            }
            .overlay {
                VStack {
                    HStack {
                        Spacer()

                        Text(card.userName)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(Color.secondary)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                    }

                    Spacer()
                }
                .padding(16)
            }
    }

    private var imageCard: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.clear)
            .aspectRatio(1.58, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 4)
            }
    }

    private var textView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.fullName)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .multilineTextAlignment(.leading)

            Text(card.userName)
                .font(.subheadline)
                .lineLimit(1)
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
        // TODO: 修正
        Image("default")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    VStack {
        CardView(card: .stub0)
        CardView(card: .stub0)
        CardView(card: .stub0)
    }
    .padding()
}
