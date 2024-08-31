//
//  MyChallengePostData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation

struct MyChallengePostData: Codable {
    let status: Int
    let data: [MyChallengePost]?
}

struct MyChallengePost: Codable {
    let thumbnailUrl: String
    let recordUrl: String
    let challengePostId: Int
    let songTitle: String
    let singer: String
    let nickName: String
    let likeCount: Int
}

struct EditChallengePostData: Codable {
    
}

struct DeleteChallengePostData: Codable {
    let message: String
    let status: Int
}
