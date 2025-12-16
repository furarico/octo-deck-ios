//
//  SafariView.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.dismissButtonStyle = .close
        return vc
    }

    func updateUIViewController(_: SFSafariViewController, context _: Context) {
    }
}
