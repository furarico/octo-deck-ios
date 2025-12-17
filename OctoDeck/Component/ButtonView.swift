//
//  ButtonView.swift
//  OctoDeck
//
//  Created by 藤間里緒香 on 2025/12/17.
//
import SwiftUI

struct ButtonView: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(title) {
            onTap()
        }
    }
}
