//
//  LoginView.swift
//  OctoDeck
//  Created by 藤間里緒香 on 2025/12/17.
//

import SwiftUI

struct LoginView: View {
    let onConnectToGitHubButtonTapped: () -> Void
    var body: some View {
        ZStack {
            Image("OctoDeckBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Image("OctoDeckIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .foregroundStyle(Color.white)
                    .font(.largeTitle)
                    .bold()
                Color.clear
                    .frame(height: 8)
                Text("世界にひとつのあなたのカードで、\n挑戦と進化を振り返り、仲間とつながろう")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                Color.clear
                    .frame(height: 48)
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
