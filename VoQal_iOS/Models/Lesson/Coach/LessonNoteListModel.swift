//
//  LessonNoteListModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import Foundation

struct LessonNoteListModel {
    let status: Int
    let data: [LessonNote]?
}

struct DeleteLessonNoteModel {
    let message: String
    let status: Int
}
