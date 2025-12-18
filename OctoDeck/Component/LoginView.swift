//
//  ContentScreen.swift
//  OctoDeck
//  Created by 藤間里緒香 on 2025/12/17.
//

import SwiftUI

struct LoginView: View {
    let onTap: () -> Void
    var body: some View {
        ZStack {
            Image("OctoDeck-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image("OctoDeck-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                Text("さぁ はじめよう")
                    .foregroundColor(Color.white)
                Spacer().frame(height: 20)
                Text("テキストテキストテキストテキスト\nテキストテキストテキスト")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                Spacer().frame(height: 48)
                Button {
                    onTap()
                } label: {
                    Text("GitHub連携")
                        .accentColor(Color.white)
                        .frame(width: 132, height: 48)
                        .background(Color.cyan)
                        .clipShape(Capsule())
                }
                Spacer()
            }
        }
    }

//    @ViewBuilder
//    var git_content: some View {
//            Button {
//                Task {
//                    await viewModel.onSignInButtonTapped()
//                }
//            } label: {
//                Text("GitHub連携")
//                    .accentColor(Color.white)
//                    .frame(width: 132, height: 48)
//                    .background(Color.cyan)
//                    .clipShape(Capsule())
//            }
//        }
    }


