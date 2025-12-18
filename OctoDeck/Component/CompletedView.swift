//
//  CompletedView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/18.
//
import SwiftUI
import Lottie

struct CompletedView: View {
    var body: some View {
        ZStack {
            Image("OctoDeckBackground")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .overlay {
                    VStack(spacing: 24) {
                        LottieView(
                            name: "OctoDeckCompleted"
                        ).frame(width: 256, height: 256)
                        Text("連携完了")
                            .font(.largeTitle)
                            .bold()
                    }.foregroundStyle(Color.white)
                }
        }
    }
}

#Preview {
    CompletedView()
}
