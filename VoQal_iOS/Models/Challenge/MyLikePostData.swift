//
//  MyLikePostData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/31/24.
//

import Foundation

struct MyLikePostData: Codable {
    let status: Int
    let data: [MyLikePost]?
}

struct MyLikePost: Codable {
    let challengeId: Int
    let nickName: String
    let challengeRecordUrl: String
    let thumbnailUrl: String
    let songTitle: String
    let singer: String
}
