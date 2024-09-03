//
//  EditNicknameManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/31/24.
//

import Foundation
import Alamofire

struct editNicknameParameter: Encodable {
    let nickname: String
}

struct EditNicknameManager {
    
    func nicknameDuplicateCheck(_ nickname: String, completion: @escaping (NicknameVerifyModel?) -> Void) {
        
        let nicknameDuplicateURL: String = "https://www.voqal.today/duplicate/nickname"
        
        let parameter = nicknameParameter(nickName: nickname)
        print(nickname)
        
        AF.request(nicknameDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: NicknameVerifyData.self) { (response) in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let model = NicknameVerifyModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func editNickname(_ id: Int64, _ newNickname: String, completion: @escaping (EditNicknameModel?) -> Void) {
        let url = "https://www.voqal.today/\(id)/change-nickname"
        let parameter = editNicknameParameter(nickname: newNickname)
        
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: EditNicknameData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let model = EditNicknameModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
