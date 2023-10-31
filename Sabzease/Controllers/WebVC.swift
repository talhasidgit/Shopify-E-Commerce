//
//  WebVC.swift
//  Demo
//
//  Created by MAC on 17/04/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import WebKit
import SideMenu
import CDAlertView
import Reachability

class WebVC: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var isGuide:Bool = false
    var isRefund:Bool = false
    var reachability = try! Reachability()
    var refController:UIRefreshControl = UIRefreshControl()
    let alert = CDAlertView(title: "Network Error", message: "Please connect to the internet", type: .warning)
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        
        let menu = storyboard!.instantiateViewController(withIdentifier: "SideMenu") as! SideMenuNavigationController
        present(menu, animated: true, completion: nil)
    }
    
    //Add this progress view via Interface Builder (IBOutlet) or programatically
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    deinit {
        if !isGuide {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }else if isGuide {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func showProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1
        }, completion: nil)
    }
    
    func hideProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0
        }, completion: nil)
    }
    //Progress Bar end
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Add Pull to Refresh
        refController.bounds = CGRect(x:0, y:50, width:refController.bounds.size.width, height:refController.bounds.size.height)
        refController.addTarget(self, action: #selector(refView(refresh:)), for: UIControl.Event.valueChanged)
        refController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        webView.scrollView.addSubview(refController)
        
        //Progress Bar Setup
        [progressView].forEach { self.view.addSubview($0) }
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.setWebViewData()
        if isGuide{
            self.title = "Order Guide"
        }else{
            self.title = "Refund Policy"
        }
    }
    
    @IBAction func actMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refView(refresh:UIRefreshControl){
        
        GIFHUD.shared.setGif(named: AppConstatns.sharedInstance.apiGif)
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                GIFHUD.shared.show()
                var urlString = ""
                if self.isGuide{
                    urlString = "https://sabzease.com/pages/how-to-ordermobile-app-page"
                }else{
                    urlString = "http://api.sabzease.com/sabzease-app/return-and-exchange.html"
                }
                let url = URL(string: urlString)!
                self.webView.load(URLRequest(url: url))
                self.refController.endRefreshing()
                self.webView.navigationDelegate = self
                self.webView.addObserver(self,
                                    forKeyPath: #keyPath(WKWebView.estimatedProgress),
                                    options: .new,
                                    context: nil)
            }else{
                self.refController.endRefreshing()
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showErrorMessage()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func setWebViewData(){
        // 1
        var urlString = ""
        if self.isGuide{
            urlString = "https://sabzease.com/pages/how-to-ordermobile-app-page"
        }else{
            urlString = "http://api.sabzease.com/sabzease-app/return-and-exchange.html"
        }
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        // 2
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = true
        webView.navigationDelegate = self
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    //MARK: Web View Delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showProgressView()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            //do something with headers
            print(headers)
        }
        decisionHandler(.allow)
    }
    
    func showErrorMessage(){
        
        //        let action = CDAlertViewAction(title: "Okay")
        //        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
