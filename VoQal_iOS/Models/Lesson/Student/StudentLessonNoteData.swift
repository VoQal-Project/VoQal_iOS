//
//  StudentLessonNoteData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation

struct StudentLessonNoteData: Codable {
    let status: Int
    let data: [StudentLessonNote]?
    let message: String?
    let code: String?
    let errors: [ErrorDetail]?
}

struct StudentLessonNote: Codable {
    let lessonNoteId: Int
    let lessonNoteTitle: String
    let songTitle: String
    let singer: String
    let lessonDate: String
}
