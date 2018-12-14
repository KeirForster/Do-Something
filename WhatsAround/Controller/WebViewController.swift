//
//  WebViewController.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/27/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // variables
    var url: URL?
    
    // outlets
    @IBOutlet weak var webkitView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendUrlRequest()
    }
    
    private func sendUrlRequest() -> Void {
        guard url != nil else {
            print("no url")
            return
        }
        
        let request = URLRequest(url: url!)
        webkitView.load(request)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
