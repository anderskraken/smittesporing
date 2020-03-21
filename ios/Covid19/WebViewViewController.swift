//
//  WebviewViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 21/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import WebKit

class WebViewViewController: UIViewController {
    
    let webView = WKWebView()
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.url = URL(string: "")!
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        webView.load(URLRequest(url: url))
    }
}
