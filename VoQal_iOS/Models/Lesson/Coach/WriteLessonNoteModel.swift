//
//  WriteLessonNoteModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/27/24.
//

import Foundation

struct WriteLessonNoteModel {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}

struct UploadRecordFileModel {
    let status: Int
    let message: String?
    let errors: [ErrorDetail]?
    let code: String?
    let data: RecordResponse?
}
