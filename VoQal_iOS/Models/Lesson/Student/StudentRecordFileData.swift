//
//  StudentRecordFileData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation

struct StudentRecordFileData: Codable {
    let status: Int
    let data: [StudentRecordFile]?
    let code: String?
    let errors: [ErrorDetail]?
    let message: String?
}

struct StudentRecordFile: Codable {
    let recordId: Int
    let recordDate: String
    let recordTitle: String
    let s3Url: String
    var duration: TimeInterval?
}

