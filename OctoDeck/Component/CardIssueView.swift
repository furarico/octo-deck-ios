//
//  CardIssueView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/18.
//

import SwiftUI

struct CardIssueView: View {
    @State private var progress = 0.0

    var body: some View {
        ZStack {
            Image("OctoDeckBackground")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack(spacing: 8) {
                Text("カードを発行しています")
                    .font(.title)
                    .bold()
                Text("あなただけの輝きを、1枚のカードに")
                ProgressView(value: progress)
                    .frame(width: 217, height: 6)
                    .padding(.top, 24)
                    .tint(Color.cyan)
            }.foregroundStyle(Color.white)
        }
        .task {
            // 3秒で端から端までいくようにしてます
            // もしCard生成時間をとってこれるなら書き換えてください
            withAnimation(.linear(duration: 3)) {
                progress = 1.0
            }
        }
    }
}

#Preview {
    CardIssueView()
}
