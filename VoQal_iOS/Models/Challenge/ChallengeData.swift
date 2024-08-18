//
//  ChallengeData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation

struct ChallengeData: Codable {
    let status: Int
    let data: [ChallengePost]?
}

struct ChallengePost: Codable {
    let challengeId: Int
    let todayKeyword: String
    let thumbnailUrl: String
    let recordUrl: String
    let songTitle: String
    let singer: String
    let nickName: String
    var liked: Bool
}

struct ChallengeLikeData: Codable {
    let status: Int
    let message: String?
}

struct ChallengeUnlikeData: Codable {
    let status: Int
    let message: String?
}
