//
//  Student.swift
//  Students
//
//  Created by Andrew R Madsen on 8/5/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var course: String
    
    var firstName: String {
        let splitNames = name.split(separator: " ")
        return String(splitNames[0])
    }
    
    var lastName: String {
        let stringComponents = name.components(separatedBy: .whitespaces)
        return stringComponents.last ?? ""
    }
}
