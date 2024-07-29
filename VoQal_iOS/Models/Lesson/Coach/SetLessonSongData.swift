//
//  SetLessonSongData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/28/24.
//

import Foundation

struct SetLessonSongData: Codable {
    let status: Int
    let lessonSongUrl: String?
    let singer: String?
    let songTitle: String?
    let message: String?
    let code: String?
    let errors: [ErrorDetail]?
}
