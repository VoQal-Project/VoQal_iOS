//
//  LessonNoteDetailData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/6/24.
//

import Foundation

struct LessonNoteDetailData: Codable {
    let data: LessonNoteDetail?
    let status: Int?
}

struct LessonNoteDetail: Codable {
    let songTitle: String
    let lessonNoteTitle: String
    let contents: String
    let singer: String
    let lessonDate: String
}
