//
//  ChatData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/9/24.
//

import Foundation

struct StudentChatData: Codable {
    let status: Int
    let data: StudentChatRoomInfo?
}

struct StudentChatRoomInfo: Codable {
    let chatRoomId: String
    let coachId: Int
}

struct CoachChatData: Codable {
    let status: Int
    let data: String? // 채팅방 id
}


