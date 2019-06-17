//
//  MainViewController.swift
//  Students
//
//  Created by Sean Acres on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    
    private var studentsTableViewController: StudentsTableViewController! {
        didSet {
            updateDataSource()
        }
    }
    
    private var students: [Student] = [] {
        didSet {
            updateDataSource()
        }
    }
    private let studentController = StudentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentController.loadFromPersistentStore { students, error in
            if let error = error {
                print("Error loading students: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.students = students ?? []
            }
        }
    }
    
    @IBAction func sortSelected(_ sender: Any) {
        updateDataSource()
    }
    
    @IBAction func filterSelected(_ sender: Any) {
        updateDataSource()
    }
    
    private func updateDataSource() {
        var sortedAndFilteredStudents: [Student]
        switch filterSelector.selectedSegmentIndex {
        case 1:
            sortedAndFilteredStudents = students.filter { $0.course == "iOS" }
        case 2:
            sortedAndFilteredStudents = students.filter { $0.course == "Web" }
        case 3:
            sortedAndFilteredStudents = students.filter { $0.course == "UX" }
        default:
            sortedAndFilteredStudents = students
        }
        
        if sortSelector.selectedSegmentIndex == 0 {
            sortedAndFilteredStudents = sortedAndFilteredStudents.sorted { $0.firstName < $1.firstName }
        } else {
            sortedAndFilteredStudents = sortedAndFilteredStudents.sorted { $0.lastName < $1.lastName }
        }
        
        studentsTableViewController.students = sortedAndFilteredStudents
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        studentsTableViewController = (segue.destination as! StudentsTableViewController)
    }
}
