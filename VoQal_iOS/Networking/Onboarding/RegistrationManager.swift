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

struct registerParameter: Encodable {
    let email: String
    let password: String
    let nickName: String
    let name: String
    let phoneNum: String
}

struct RegistrationManager {
    
    private let emailDuplicateURL: String = "https://www.voqal.today/duplicate/email"
    private let nicknameDuplicateURL: String = "https://www.voqal.today/duplicate/nickname"
    private let registerURL: String = "https://www.voqal.today/signup"
    
    func emailDuplicateCheck(_ email: String, completion: @escaping (EmailVerifyModel?) -> Void ) {
        
        let parameter = emailParameter(email: email)
        
        AF.request(emailDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: EmailVerifyData.self) { (response) in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let model = EmailVerifyModel(message: message, status: status)
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
                let status = res.status
                let model = NicknameVerifyModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func registerUser(_ email: String, _ password: String, _ nickname: String, _ name: String, _ phoneNum: String, completion: @escaping (RegistrationModel?) -> Void) {
        
        let parameter = registerParameter(email: email, password: password, nickName: nickname, name: name, phoneNum: phoneNum)
        
        AF.request(registerURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: RegistrationData.self) { (response) in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let error = res.error
                let model = RegistrationModel(status: status, error: error, message: message)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
}

