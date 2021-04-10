//
//  WebViewController.swift
//  ESPullToRefreshExample
//
//  Created by lihao on 16/5/6.
//  Copyright © 2016年 egg swift. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController, UIWebViewDelegate,WKUIDelegate {

    @IBOutlet weak var networkTipsButton: UIButton!
    @IBOutlet weak var webViewXib: WKWebView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.webViewXib {
            self.webView = self.webViewXib
        } else {
            let webConfiguration = WKWebViewConfiguration()
            self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
            self.webView.frame = self.view.bounds
            self.view.addSubview(self.webView!)
        }
        
        self.webView!.uiDelegate = self
        
        let url = "https://github.com/eggswift"
        self.title = "egg swift"
     
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
       // self.webView.scrollView.es.stopPullToRefresh()
        self.webView.scrollView.bounces = true
        self.webView.scrollView.alwaysBounceVertical = true
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
       // self.webView.scrollView.es.stopPullToRefresh(ignoreDate: true)
        self.networkTipsButton.isHidden = false
    }

    @IBAction func networkRetryAction(_ sender: AnyObject) {
        self.networkTipsButton.isHidden = true
        UIView.performWithoutAnimation {
            //self.webView.scrollView.es.startPullToRefresh()
        }
    }
}
