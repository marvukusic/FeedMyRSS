//
//  WebView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 08.11.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable{
    @Binding var isLoading: Bool
    
    var url: URL?
    
    func makeUIView(context: Context) -> some UIView {
        guard let url else {
            return WKWebView()
        }
        
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        webview.load(URLRequest(url: url))
        return webview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
