//
//  ChatModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/9/24.
//

import Foundation

struct StudentChatModel {
    let status: Int
    let data: StudentChatRoomInfo?
}

struct CoachChatModel {
    let status: Int
    let data: String?
}

struct ChatMessageModel {
    let status: Int
    let data: [ChatMessage]
}
