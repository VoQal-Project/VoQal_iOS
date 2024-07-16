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
    private let loginUrl = "https://www.voqal.today/login"
    private let coachApprovalStatusUrl = "https://www.voqal.today/check/status"
    
    func loginUser(_ email: String, _ password: String, completion: @escaping (LoginModel?) -> Void) {
        
        let parameter = LoginParameter(email: email, password: password)
        
        AF.request(loginUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginData.self) { response in
            switch response.result {
            case .success(let res):
                print(res.status)
                let status = res.status
                let accessToken = res.accessToken
                let refreshToken = res.refreshToken
                let role = res.role
                let model = LoginModel(status: status, accessToken: accessToken, refreshToken: refreshToken, role: role)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func checkCoachApprovalStatus() {
        
    }
    
}
