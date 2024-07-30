//
//  ManageStudentData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/23/24.
//

import Foundation

struct ManageStudentData: Codable {
    let message: String?
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
    let data: [ApprovedStudent]?
}

struct ApprovedStudent: Codable {
    let id: Int
    let name: String
    let lessonSongUrl: String?
    let singer: String?
    let songTitle: String?
}

struct DeleteStudentData: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
