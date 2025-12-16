//
//  CardView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/15.
//

import NukeUI
import SwiftUI

import SwiftUI

extension DomainColor {
    var swiftUIColor: Color {
        Color(
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0
        )
    }
}

struct IdenticonView: View {
    let identicon: Identicon

    var body: some View {
        GeometryReader { geo in
            let rows = identicon.blocks.count
            let cols = identicon.blocks.first?.count ?? 0
            let blockSize = min(
                geo.size.width / CGFloat(cols),
                geo.size.height / CGFloat(rows)
            )

            VStack(spacing: 0) {
                ForEach(identicon.blocks.indices, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(identicon.blocks[row].indices, id: \.self) { col in
                            Rectangle()
                                .fill(
                                    identicon.blocks[row][col]
                                    ? identicon.color.swiftUIColor
                                    : Color.clear
                                )
                                .frame(
                                    width: blockSize,
                                    height: blockSize
                                )
                        }
                    }
                }
            }
            .frame(
                width: blockSize * CGFloat(cols),
                height: blockSize * CGFloat(rows)
            )
            .centered(in: geo.size)
        }
    }
}
private extension View {
    func centered(in size: CGSize) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .position(x: size.width / 2, y: size.height / 2)
    }
}


struct CardView: View {
    let card: Card
    var body: some View {
        imageCard
            .overlay {
                HStack {
                    image
                        .frame(width: 80, height: 80)
                    textView
                }
            }
    }

    private var imageCard: some View {
        GeometryReader { geo in
            ZStack {
                Image("Card-background")
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                IdenticonView(identicon: card.identicon)
                    .opacity(0.25)
                    .blur(radius: 6)
                Image("Card-HighLight")

            }
            .frame(
                width: geo.size.width * 0.9,
                height: geo.size.height * 0.28
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var textView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(card.fullName)
                .font(.body)
                .bold()
                .lineLimit(1)
                .multilineTextAlignment(.leading)
            Text(card.userName)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }

    private var image: some View {
        GeometryReader { geo in
            ZStack {
                let size = geo.size.width
                let scale: CGFloat = 1.15
                let scaledSize = size * scale
                Image("Card-icon-circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: scaledSize, height: scaledSize)
                    .position(x: size / 2, y: size / 2)
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    .frame(width: scaledSize, height: scaledSize)
                    .position(x: size / 2, y: size / 2)
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
                .frame(width: size, height: size)
                .clipShape(Circle())
            }
        }
        .frame(width: 80, height: 80)
    }

    private var defaultImage: some View {
        // TODO: 修正
        Image("default")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    CardView(card: .stub0)
        .padding()
}
