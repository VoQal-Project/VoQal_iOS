//
//  WriteLessonNoteData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/27/24.
//

import Foundation

struct WriteLessonNoteData: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}


struct UploadRecordFileData: Codable {
    let status: Int
    let message: String?
    let errors: [ErrorDetail]?
    let code: String?
    let data: RecordResponse?
}

struct RecordResponse: Codable {
    let recordDate: String
    let recordTitle: String
    let s3Url: String
}
