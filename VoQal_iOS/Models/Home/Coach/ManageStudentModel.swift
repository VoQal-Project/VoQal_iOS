//
//  ManageStudentModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/23/24.
//

import Foundation

struct ManageStudentModel {
    let status: Int
    let students: [ApprovedStudent]
    
    var sortedStudents: [ApprovedStudent] {
        students.sorted { firstStudent, secondStudent in
            let firstId = firstStudent.id
            let secondId = secondStudent.id
            return firstId > secondId
        }
    }
}

struct DeleteStudentModel {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
