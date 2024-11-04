//
//  LessonNoteListData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import Foundation

struct LessonNoteListData: Codable {
    let status: Int
    let data: [LessonNote]?
}

struct LessonNote: Codable {
    let lessonNoteId: Int
    let lessonNoteTitle: String
    let songTitle: String
    let singer: String
    let lessonDate: String
}

struct DeleteLessonNoteData: Codable {
    let message: String
    let status: Int
}
