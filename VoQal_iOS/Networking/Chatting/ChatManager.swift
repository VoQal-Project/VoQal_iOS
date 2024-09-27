//
//  ChatManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/9/24.
//

import Foundation
import Alamofire

struct SearchChatRoomFromCoachParameter: Encodable {
    let studentId: Int64
}

struct ChatMessageParameterToSend: Encodable {
    let receiverId: Int64
    let message: String
}

struct ChatManager {
    
    func fetchMessages(_ chatId: String, completion: @escaping (ChatMessageModel?) -> Void) {
        let url = "https://www.voqal.today/chat/\(chatId)/messages"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: ChatMessageData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = ChatMessageModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func searchChatRoomFromStudent(completion: @escaping (StudentChatModel?) -> Void) {
        let url = "https://www.voqal.today/chat/room"
        
        AF.request(url, method: .post, interceptor: AuthInterceptor()).responseDecodable(of: StudentChatData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = StudentChatModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func searchChatRoomFromCoach(_ studentId: Int64, completion: @escaping (CoachChatModel?) -> Void) {
        let url = "https://www.voqal.today/chat/room/\(studentId)"
        let parameter = SearchChatRoomFromCoachParameter(studentId: studentId)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: CoachChatData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = CoachChatModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func sendMessage(_ chatId: String, _ receiverId: Int64, _ message: String ,completion: @escaping (SendMessageModel?) -> Void) {
        let url = "https://www.voqal.today/chat/\(chatId)/message"
        let parameter = ChatMessageParameterToSend(receiverId: receiverId, message: message)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: SendMessageData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let model = SendMessageModel(status: status, message: message)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}
