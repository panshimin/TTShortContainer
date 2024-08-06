//
//  TopViewController.swift
//  ShortContainer
//
//  Created by psm on 2024/7/22.
//

import Foundation
import UIKit
import WebKit

class TopViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        
        let myURL = URL(string:"https://www.apple.com.cn/")
        let myRequest = URLRequest(url: myURL!)
        webView.scrollView.contentSize = self.view.bounds.size
        webView.frame = self.view.bounds
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension TopViewController: TTShortScrollViewProvider {
    
    func shortScrollView() -> UIScrollView? {
        return webView.scrollView
    }
}

extension TopViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print("error: \(error)")
    }
}
