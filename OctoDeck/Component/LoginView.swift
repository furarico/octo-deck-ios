//
//  LoginView.swift
//  OctoDeck
//  Created by 藤間里緒香 on 2025/12/17.
//

import SwiftUI

struct LoginView: View {
    let onConnectToGitHubButtonTapped: () -> Void
    var body: some View {
        Image("OctoDeckBackground")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .overlay {
                VStack(spacing: 48) {
                    VStack {
                        Image("OctoDeckIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)

                        VStack(spacing: 8) {
                            Text("さぁ はじめよう")
                                .font(.largeTitle)
                                .bold()
                            Text(
                                 """
                                 世界にひとつのあなたのカードで、
                                 挑戦と進化を振り返り、仲間とつながろう
                                 """
                            )
                            .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(Color.white)
                    }

                    Button("GitHub連携") {
                        onConnectToGitHubButtonTapped()
                    }
                    .buttonStyle(.glassProminent)
                }
            }
    }
}

#Preview {
    LoginView(onConnectToGitHubButtonTapped: {})
}
