//
//  appStoreWebViewController.swift
//  DAL_iOS_StarterKit
//
//  Created by Thulasingam, Bhakeeswaran on 2/11/16.
//  Copyright © 2016 Amgen. All rights reserved.
//

import UIKit
import WebKit

class AppStoreViewController: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var appStore: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewRelic.recordEvent("Show AppStore", attributes: ["action":"tapped"])
        loadAppStoreURL()
    }
    
    func loadAppStoreURL(){
        let appStoreURL = NSURL (string: ConfigSettings.sharedInstance.AppStoreURL);
        let urlRequest = NSURLRequest(URL: appStoreURL!);
        appStore!.loadRequest(urlRequest);
    }
    
    
    func customNewRelicInteractionName() -> NSString
    {
        return "App store View"
    }
}
