//
//  RequestListData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import Foundation

struct RequestListData: Codable {
    
    let status: Int?
    let data: [Student]
    
}

struct Student: Codable {
    let studentId: Int?
    let studentName: String?
}

struct ApproveStudentData: Codable {
    
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
    
}

struct RejectStudentData: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
