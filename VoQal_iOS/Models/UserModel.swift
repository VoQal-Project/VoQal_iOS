//
//  UserModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/16/24.
//

import Foundation

struct UserModel: Codable, Equatable {
    let memberId: Int?
    let email: String?
    let nickname: String?
    let name: String?
    let phoneNum: String?
    let role: String?
    let lessonSongUrl: String?
    let assignedCoach: String?
}


