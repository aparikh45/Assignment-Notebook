//
//  Assignment.swift
//  Assignment Notebook
//
//  Created by Arnav Parikh on 2/6/19.
//  Copyright © 2019 Arnav Parikh. All rights reserved.
//

import UIKit

class Assignment: Codable {
    
    
    var assignmentName : String
    var course : String
    var dueDate : String
    var details : String
    
    init(assignmentName: String, course: String, dueDate: String, details: String) {
        self.assignmentName = assignmentName
        self.course = course
        self.dueDate = dueDate
        self.details = details
    }
    
}
