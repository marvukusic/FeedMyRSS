//
//  WebView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 08.11.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable{
    var url: URL?
    
    func makeUIView(context: Context) -> some UIView {
        guard let url else {
            return WKWebView()
        }
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        return webview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
