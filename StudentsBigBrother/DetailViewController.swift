//
//  DetailViewController.swift
//  StudentsBigBrother
//
//  Created by student on 31.10.16.
//  Copyright © 2016 StudentsBigBrother. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

//    @IBOutlet weak var detailDescriptionLabel: UILabel!
    

    @IBOutlet var studentsFilesWebView: UIWebView!
    
    var files: [[String: [String: AnyObject]]]?

    var detailItem: Int? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        let _ = self.view
        if let detail = self.detailItem {
            
            let studentId = detail;
            
            if let myWebview = studentsFilesWebView {
                let userPasswordString = "123:123 "
                let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
                let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
                let authString = "Basic \(base64EncodedCredential)"
                
                
                let url = URL(string: "http://54.213.202.245/students/\(studentId)")
                var request = URLRequest(url: url!)
                request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
                myWebview.scalesPageToFit = true
                myWebview.loadRequest(request)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

