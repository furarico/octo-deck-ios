//
//  CardView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/15.
//

import NukeUI
import SwiftUI

struct CardView: View {
    private let card: Card
    private let isMini: Bool
    private let overrideColor: Color?
    private var languageColor: Color {
        let domainColor = card.mostUsedLanguage.color
        return Color(domainColor: domainColor)
    }

    init(card: Card, isMini: Bool = false, overrideColor: DomainColor? = nil) {
        self.card = card
        self.isMini = isMini
        self.overrideColor = overrideColor.map { Color(red: $0.r, green: $0.g, blue: $0.b) }
    }

    private let gradient = LinearGradient(
        stops: [
            .init(color: Color.white, location: 0),
            .init(color: Color.white, location: 0.1),
            .init(color: Color(red: 110/255, green: 110/255, blue: 255/255), location: 0.2),
            .init(color: Color(red: 255/255, green: 78/255, blue: 143/255), location: 0.25),
            .init(color: Color(red: 208/255, green: 255/255, blue: 126/255), location: 0.3),
            .init(color: Color(red: 0/255, green: 194/255, blue: 29/255), location: 0.35),
            .init(color: Color.white, location: 0.45),
            .init(color: Color.white, location: 0.55),
            .init(color: Color(red: 110/255, green: 110/255, blue: 255/255), location: 0.65),
            .init(color: Color(red: 255/255, green: 78/255, blue: 143/255), location: 0.7),
            .init(color: Color(red: 208/255, green: 255/255, blue: 126/255), location: 0.75),
            .init(color: Color(red: 0/255, green: 194/255, blue: 29/255), location: 0.8),
            .init(color: Color.white, location: 0.9),
            .init(color: Color.white, location: 1),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    private var colorGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: overrideColor ?? languageColor, location: 0),
                .init(color: overrideColor ?? languageColor, location: 0.1),
                .init(color: Color.clear, location: 0.2),
                .init(color: Color.clear, location: 0.35),
                .init(color: overrideColor ?? languageColor, location: 0.45),
                .init(color: overrideColor ?? languageColor, location: 0.55),
                .init(color: Color.clear, location: 0.65),
                .init(color: Color.clear, location: 0.8),
                .init(color: overrideColor ?? languageColor, location: 0.9),
                .init(color: overrideColor ?? languageColor, location: 1),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        cardBackground
            .overlay {
                HStack {
                    Spacer()
                    IdenticonView(identicon: card.identicon)
                        .opacity(0.4)
                        .padding(isMini ? 8 : 20)
                }
            }
            .overlay {
                HStack(spacing: isMini ? 8 : 16) {
                    image
                        .frame(width: isMini ? 32 : 80, height: isMini ? 32 : 80)
                        .clipped()
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(gradient, lineWidth: isMini ? 1 : 2)
                        }
                        .shadow(
                            color: overrideColor ?? languageColor,
                            radius: isMini ? 8 : 12
                        )

                    textView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(isMini ? 8 : 20)
            }
            .overlay {
                if !isMini {
                    VStack {
                        HStack {
                            Spacer()

                            Text(card.userName)
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(Color.gray)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)
                        }

                        Spacer()
                    }
                    .padding(16)
                }
            }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.white)
            .aspectRatio(1.58, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(gradient.opacity(0.2))
                    .stroke(gradient, lineWidth: isMini ? 2 : 4)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorGradient.opacity(0.4))
            }
            .shadow(
                color: overrideColor ?? languageColor,
                radius: isMini ? 8 : 12
            )
    }

    private var textView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !isMini {
                Text(card.fullName)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.black)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }

            Text(card.userName)
                .font(isMini ? .caption2 : .subheadline)
                .bold(isMini)
                .foregroundStyle(Color.black)
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
    CardView(card: .stub0)
        .padding()
}

#Preview {
    CardView(card: .stub1)
        .padding()
}

#Preview {
    CardView(card: .stub0, isMini: true)
        .frame(maxWidth: 120)
        .padding()
}

#Preview {
    CardView(card: .stub1, isMini: true)
        .frame(maxWidth: 120)
        .padding()
}
