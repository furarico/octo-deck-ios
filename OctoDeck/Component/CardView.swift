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

    private let gradient = LinearGradient(
        stops: [
            .init(color: Color(red: 219/255, green: 219/255, blue: 219/255), location: 0),
            .init(color: Color.white, location: 0.081),
            .init(color: Color(red: 110/255, green: 110/255, blue: 255/255), location: 0.150),
            .init(color: Color(red: 255/255, green: 78/255, blue: 143/255), location: 0.192),
            .init(color: Color(red: 208/255, green: 255/255, blue: 126/255), location: 0.286),
            .init(color: Color(red: 0/255, green: 194/255, blue: 29/255), location: 0.354),
            .init(color: Color.white, location: 0.446),
            .init(color: Color.white, location: 0.574),
            .init(color: Color(red: 110/255, green: 110/255, blue: 255/255), location: 0.695),
            .init(color: Color(red: 255/255, green: 78/255, blue: 143/255), location: 0.768),
            .init(color: Color(red: 208/255, green: 255/255, blue: 126/255), location: 0.855),
            .init(color: Color(red: 0/255, green: 194/255, blue: 29/255), location: 0.918),
            .init(color: Color(red: 225/255, green: 225/255, blue: 225/255), location: 1),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

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
                                .stroke(gradient.opacity(0.7), lineWidth: 2)
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
                            .foregroundStyle(Color.gray)
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
            .fill(Color.white)
            .aspectRatio(1.58, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(gradient.opacity(0.12))
                    .stroke(gradient.opacity(0.7), lineWidth: 4)
            }
    }

    private var textView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.fullName)
                .font(.title2)
                .bold()
                .foregroundStyle(Color.black)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.black)

            Text(card.userName)
                .font(.subheadline)
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
    VStack {
        CardView(card: .stub0)
        CardView(card: .stub1)
    }
    .padding()
}
