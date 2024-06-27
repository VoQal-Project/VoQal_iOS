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
    
    func emailDuplicateCheck(_ email: String) {
        
        let parameter = emailParameter(email: email)
//        
//        AF.request(emailDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: RegistrationData.self) { (response) in
//            switch response.result {
//            case .success(let res):
//                print(res)
//            case .failure(let err):
//                print(err)
//            }
//        }
        
        AF.request(emailDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response data: \(utf8Text)")
            }

            switch response.result {
            case .success(let data):
                // Handle successful response
                print("Request succeeded with response data: \(data)")
            case .failure(let error):
                // Handle failure
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func nicknameDuplicateCheck(_ nickname: String) {
        
        let parameter = nicknameParameter(nickname: nickname)
        
        AF.request(nicknameDuplicateURL, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: RegistrationData.self) { (response) in
            switch response.result {
            case .success(let res):
                print(res)
            case .failure(let err):
                print(err)
            }
        }
        
    }
}

