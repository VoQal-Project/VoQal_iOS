//
//  ChatManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/9/24.
//

import Foundation
import Alamofire

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
    
    func searchChatRoomFromCoach() {
        
    }
    
}
