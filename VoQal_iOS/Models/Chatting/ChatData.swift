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

struct ChatMessageData: Codable {
    let status: Int
    let data: ChatMessageDetailData
}

struct ChatMessageDetailData: Codable {
    let coachLastReadTime: Int64?
    let studentLastReadTime: Int64?
    let messages: [ChatMessage]
}

struct ChatMessage: Codable {
    let receiverId: String
    let message: String
    let timestamp: Int
}

struct ChatMessageToSend: Codable {
    let receiverId: Int64
    let message: String
}

struct SendMessageData: Codable {
    let status: Int
    let message: String
}
