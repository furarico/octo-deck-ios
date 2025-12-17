//
//  ContentScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/14.
//

import SwiftUI

extension UIFont.TextStyle {
    static var emphasizedLargeTitle: UIFont.TextStyle {
        return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedTitle0")
    }
    static var sfProDisplayMedium: UIFont.TextStyle {
        return UIFont.TextStyle(rawValue: "SFProText-Medium")
    }
}

struct ContentScreen: View {
    @State private var viewModel = ContentViewModel()
    var body: some View {
        ZStack{
        Image("OctoDeck-background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            VStack{
                Spacer()
            Image("OctoDeck")
                .resizable()
                .scaledToFit()
                .frame(width:160, height:160)
                Text("さぁ はじめよう")
                    .foregroundColor(Color.white)
                    .font(Font(UIFont.preferredFont(forTextStyle: .emphasizedLargeTitle)))
                Spacer().frame(height:20)
                Text("テキストテキストテキストテキスト\nテキストテキストテキスト")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                Spacer().frame(height:48)
                content
                    .task {
                        await viewModel.onAppear()
                    }
                    .sheet(item: $viewModel.safariViewURL) { item in
                        SafariView(url: item.url)
                    }
                    .onOpenURL { url in
                        Task {
                            await viewModel.handleURL(url)
                        }
                    }
                Spacer()
            }
        }

    }

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let user = viewModel.authenticatedUser {
            tabView(user: user)
        } else {
            Button{
                Task {
                    await viewModel.onSignInButtonTapped()
                }
            }label:{
                Text(("GitHub連携"))
                .accentColor(Color.white)
                .frame(width:132, height:48)
                    .font(Font(UIFont.preferredFont(forTextStyle: .sfProDisplayMedium)).pointSize(16))
                    .background(Color.cyan)
                    .clipShape(Capsule())


            }
        }
    }

    func tabView(user: User) -> some View {
        TabView {
            Tab("My Deck", systemImage: "person.crop.rectangle.stack") {
                MyDeckScreen()
            }

            Tab("Debug", systemImage: "info.circle") {
                VStack {
                    Text("Hi! \(user.fullName).")

                    Button("Sign Out") {
                        Task {
                            await viewModel.onSignOutButtonTapped()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentScreen()
}

