//
//  LoginManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import Foundation
import Alamofire

struct LoginParameter: Encodable {
    let email: String
    let password: String
}

struct LoginManager {
    private let url = "https://www.voqal.today/login"
    
    func LoginUser(_ email: String, _ password: String, completion: @escaping (LoginModel?) -> Void) {
        
        let parameter = LoginParameter(email: email, password: password)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginData.self) { response in
            switch response.result {
            case .success(let res):
                print(res.status)
                let status = res.status
                let accessToken = res.accessToken
                let refreshToken = res.refreshToken
                let model = LoginModel(status: status, accessToken: accessToken, refreshToken: refreshToken)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
}
