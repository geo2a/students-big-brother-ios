//
//  MasterViewController.swift
//  StudentsBigBrother
//
//  Created by student on 31.10.16.
//  Copyright © 2016 StudentsBigBrother. All rights reserved.
//

import Foundation
import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    var students: [[String: AnyObject]]?
    var student_ids: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let students_endpoint: String = "http://54.213.202.245:8083/students"
        guard let url = URL(string: students_endpoint) else {
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
                guard let students = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: AnyObject]] else {
                    print("error trying to convert data to JSON")
                    return
                }
                self.students = students
                
                self.student_ids = self.students!.map {student in student["student_id"] as! Int}
                semaphore.signal()
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        semaphore.wait()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as!
                UINavigationController).topViewController
                as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: AnyObject) {
        objects.insert(Date() as AnyObject, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let studentId = student_ids![indexPath.row]

                let controller = (segue.destination
                    as! UINavigationController).topViewController
                    as! DetailViewController
                
                controller.detailItem = studentId as AnyObject?
                controller.navigationItem.leftBarButtonItem =
                    splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Number ob master TableView items is set to number of stundets
        return student_ids!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
            for: indexPath)
        
        // Title of each master TableView item set to students last name
        cell.textLabel!.text = (students![indexPath.row])["last_name"] as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

