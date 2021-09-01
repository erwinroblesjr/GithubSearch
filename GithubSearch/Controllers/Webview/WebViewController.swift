//
//  WebViewController.swift
//
//  Created by Erwin Robles on 8/30/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    private var webUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: webUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func setWebUrl(webUrl: String){
        self.webUrl = webUrl
    }

}
