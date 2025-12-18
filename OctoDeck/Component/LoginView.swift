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
                //Spacer()
                Image("OctoDeckIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                Text("さぁ はじめよう")
                    .foregroundColor(Color.white)
                Color.clear
                    .frame(height: 20)
                Text("世界にひとつのあなたのカードで、\n挑戦と進化を振り返り、仲間とつながろう")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                Color.clear
                    .frame(height: 48)
                Button {
                    onConnectToGitHubButtonTapped()
                } label: {
                    Text("GitHub連携")
                        .foregroundColor(Color.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.cyan)
                        .clipShape(Capsule())
                }
               // Spacer()
            }
        }
    }
}

#Preview {
    LoginView(onConnectToGitHubButtonTapped: {})
}
