//
//  PasswordResetManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/29/24.
//

import Foundation
import Alamofire

struct PasswordResetParameter: Encodable {
    let email: String
    let password: String
}

struct PasswordResetManager {
    private let url = "https://www.voqal.today/reset/password"
    
    func resetPassword(_ email: String, _ password: String, completion: @escaping (PasswordResetModel?) -> Void) {
        
        let parameter = PasswordResetParameter(email: email, password: password)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: PasswordResetData.self) { (response) in
            switch response.result {
            case .success(let data):
                let message = data.message
                let code = data.code
                let status = data.status
                let errors = data.errors
                let model = PasswordResetModel(message: message, status: status, errors: errors, code: code)
                print("결과: \(model)")
                completion(model)
                
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
}
