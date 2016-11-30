//
//  DetailViewController.swift
//  StudentsBigBrother
//
//  Created by student on 31.10.16.
//  Copyright © 2016 StudentsBigBrother. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var files: [[String: [String: AnyObject]]]?

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let studentId = detail.description!
                // Download files for given students id
                let student_files_endpoint: String = "http://54.213.202.245:8083/files?s_id=\(studentId)"
                guard let url = URL(string: student_files_endpoint) else {
                    print("Error: cannot create URL")
                    return
                }
                let urlRequest = URLRequest(url: url)
                
                let config = URLSessionConfiguration.default
                let userPasswordString = "123:123 "
                let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
                let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
                let authString = "Basic \(base64EncodedCredential)"
                config.httpAdditionalHeaders = ["Authorization" : authString]
                
                let semaphore = DispatchSemaphore.init(value: 0);
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: urlRequest) {
                    (data, response, error) in
                    // check for any errors
                    guard error == nil else {
                        print("error calling GET on /students")
                        print(error)
                        return
                    }
                    // make sure we got data
                    guard let responseData = data else {
                        print("Error: did not receive data")
                        return
                    }
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard let files = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: [String: AnyObject]]] else {
                            print("error trying to convert data to JSON")
                            return
                        }
                        self.files = files
                        semaphore.signal()
                    } catch  {
                        print("error trying to convert data to JSON")
                        return
                    }
                }
                task.resume()
                semaphore.wait()
                
                label.text = String(files!.count)
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

