//
//  MyDeckScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import SwiftUI

struct MyDeckScreen: View {
    @State private var viewModel: MyDeckViewModel

    init(viewModel: MyDeckViewModel = MyDeckViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
    }

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let myCard = viewModel.myCard {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading) {
                        Text("My Card")
                            .font(.title)
                            .bold()

                        CardView(card: myCard)
                    }

                    VStack(alignment: .leading) {
                        Text("My Deck")
                            .font(.title)
                            .bold()

                        CardStackView(cards: viewModel.cardsInMyDeck)
                    }
                }
                .padding()
            }
        } else {
            Text("No card available.")
        }
    }
}

import Dependencies

#Preview {
    MyDeckScreen()
}
