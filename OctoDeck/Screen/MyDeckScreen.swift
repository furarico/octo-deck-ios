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
                VStack(alignment: .leading) {
                    Text("My Card")
                        .font(.title)
                        .bold()

                    CardView(card: myCard)
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
    let viewModel = withDependencies {
        $0.cardRepository.getMyCard = {
            .stub0
        }
    } operation: {
        MyDeckViewModel()
    }

    MyDeckScreen(viewModel: viewModel)
}
