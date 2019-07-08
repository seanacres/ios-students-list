//
//  StudentController.swift
//  Students
//
//  Created by Sean Acres on 7/8/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

class StudentController {
    
    private let studentsURL = URL(string: "https://tasks-3f211.firebaseio.com/students.json")!
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: studentsURL) { (data, response, error) in
            if let error = error {
                NSLog("error fetching students: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(nil, NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let students = try decoder.decode([Student].self, from: data)
                completion(students, nil)
            } catch {
                NSLog("Error decoding from data: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
}
