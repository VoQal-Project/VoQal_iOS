//
//  StudentLessonNoteModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation

struct StudentLessonNoteModel {
    let status: Int
    let data: [StudentLessonNote]
    
    var sortedData: [StudentLessonNote] {
        data.sorted(by: { firstLessonNote, secondLessonNote in
            let firstDate = firstLessonNote.lessonDate
            let secondDate = secondLessonNote.lessonDate
            
            return firstDate > secondDate
        })
    }
}
