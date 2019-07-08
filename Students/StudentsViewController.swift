//
//  StudentsViewController.swift
//  Students
//
//  Created by Sean Acres on 7/8/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {

    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let studentController = StudentController()
    private var students: [Student] = [] {
        didSet {
            updateDataSource()
        }
    }
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        studentController.loadFromPersistentStore { (students, error) in
            if let error = error {
                //should show alert to user
                NSLog("error loading students: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.students = students ?? []
            }
        }
    }
    

    @IBAction func sort(_ sender: Any) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: Any) {
        updateDataSource()
    }

    private func updateDataSource() {
        var updatedStudents: [Student]
        
        switch filterSelector.selectedSegmentIndex {
        case 1:
            updatedStudents = students.filter({ $0.course == "iOS" })
        case 2:
            updatedStudents = students.filter({ $0.course == "Web" })
        case 3:
            updatedStudents = students.filter({ $0.course == "UX" })
        default:
            updatedStudents = students
        }
        
        if sortSelector.selectedSegmentIndex == 0 {
            updatedStudents = updatedStudents.sorted(by: { $0.firstName < $1.firstName })
        } else {
            updatedStudents = updatedStudents.sorted(by: { $0.lastName < $1.lastName })
        }
        
        filteredAndSortedStudents = updatedStudents
    }

}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let student = filteredAndSortedStudents[indexPath.row]
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.course
        return cell
    }
}
