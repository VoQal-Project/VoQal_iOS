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
    private let checkStudentStatusUrl = "https://www.voqal.today/status/check"
    
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
    
    func checkStudentStatus(completion: @escaping (StudentStatusModel?) -> Void) {
        AF.request(checkStudentStatusUrl, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: StudentStatusData.self) { response in
            switch response.result {
            case .success(let res):
                print()
                print(res)
                let status = res.status
                let data = res.data
                let message = res.message
                let errors = res.errors
                let code = res.code
                let model = StudentStatusModel(status: status, message: message, errors: errors, code: code, data: data)
                completion(model)
                
            case .failure(let err):
                print(err)
                completion(nil)
        }
        }
    }
    
}
