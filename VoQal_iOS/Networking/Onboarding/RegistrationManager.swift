//
//  RegistrationManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/25/24.
//

import Foundation
import Alamofire

struct emailParameter: Encodable {
    let email: String
}

struct nicknameParameter: Encodable {
    let nickname: String
}

struct RegistrationManager {
    
    private let emailDuplicateURL: String = "https://voqal.codns.com/duplicate/email"
    private let nicknameDuplicateURL: String = "https://voqal.codns.com/duplicate/nickname"
    
    func emailDuplicateCheck(_ email: String, completion: @escaping (EmailVerifyModel?) -> Void ) {
        
        let parameter = emailParameter(email: email)
        
        AF.request(emailDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: EmailVerifyData.self) { (response) in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let model = EmailVerifyModel(message: message)
                completion(model)
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
    func nicknameDuplicateCheck(_ nickname: String, completion: @escaping (NicknameVerifyModel?) -> Void) {
        
        let parameter = nicknameParameter(nickname: nickname)
        
        AF.request(nicknameDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: NicknameVerifyData.self) { (response) in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let model = NicknameVerifyModel(message: message)
                completion(model)
            case .failure(let err):
                print(err)
            }
        }
        
    }
}

