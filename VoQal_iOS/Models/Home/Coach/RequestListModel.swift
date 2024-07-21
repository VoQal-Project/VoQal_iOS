//
//  RequestListModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import Foundation

struct RequestListModel {
    let status: Int
    let students: [Student]
}

struct ApproveStudentModel: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}

struct RejectStudentModel: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
