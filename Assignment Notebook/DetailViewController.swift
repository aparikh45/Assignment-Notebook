//
//  DetailViewController.swift
//  Assignment Notebook
//
//  Created by Arnav Parikh on 2/6/19.
//  Copyright © 2019 Arnav Parikh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var assignmentNameTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    
    var detailItem: Assignment? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func configureView() {
        if let assignment = self.detailItem {
            if assignmentNameTextField != nil {
                assignmentNameTextField.text = assignment.assignmentName
                courseTextField.text = assignment.course
                dueDateTextField.text = String(assignment.dueDate)
                detailsTextField.text = assignment.details
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let assignment = self.detailItem {
            assignment.course = courseTextField.text!
            assignment.dueDate = dueDateTextField.text!
            assignment.details = detailsTextField.text!
        }
    }
}
