//
//  NoticeView.swift
//  2021SWhackathon_KNUCSE
//
//  Created by 서경섭 on 2021/07/23.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class NoticeView : UIViewController, WKUIDelegate{

    var URL:URL!
    
    var webView : WKWebView!{
        didSet{
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            webView.allowsBackForwardNavigationGestures = true
            
            let request = URLRequest(url: URL)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        webView = WKWebView()
    }
    
    func addView(){
        self.view.addSubview(webView)
    }
    
    func setupConstraints(){
        webView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
}
