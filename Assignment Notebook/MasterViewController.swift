//
//  MasterViewController.swift
//  Assignment Notebook
//
//  Created by Arnav Parikh on 2/6/19.
//  Copyright © 2019 Arnav Parikh. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var assignments = [Assignment]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        if let savedData = defaults.object(forKey: "Data") as? Data {
            if let decoded = try? JSONDecoder().decode([Assignment].self, from: savedData) {
                assignments = decoded
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
        saveData()
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Add Assignment", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Assignment"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Due Date"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Course"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Details"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let insertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let assignmentTextField = alert.textFields![0] as UITextField
            let dueDuteTextField = alert.textFields![1] as UITextField
            let courseTextField = alert.textFields![2] as UITextField
            let detailsTextField = alert.textFields![3] as UITextField
            let assignment = Assignment(assignmentName: assignmentTextField.text!, course: courseTextField.text!, dueDate: dueDuteTextField.text!, details: detailsTextField.text!)
            self.assignments.append(assignment)
            self.tableView.reloadData()
            self.saveData()
        }
        
        alert.addAction(insertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(assignments) {
            defaults.set(encoded, forKey: "Data")
        }
    }
    
    // MARK: - Segues
    
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = assignments[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = assignments[indexPath.row]
        cell.textLabel!.text = object.assignmentName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            assignments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let objectToMove = assignments.remove(at: sourceIndexPath.row)
        assignments.insert(objectToMove, at: destinationIndexPath.row)
        saveData()
    }
}
