//
//  AuthInterceptor.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/12/24.
//

import Alamofire
import KeychainAccess

struct refreshAccessTokenParameter: Encodable {
    let refreshToken: String
}

struct AuthInterceptor: RequestInterceptor {
    
    private let keychain = Keychain(service: "com.yourapp.service")
    
    private var accessToken: String? {
        return keychain["accessToken"]
    }
    
    private var refreshToken: String? {
        return keychain["refreshToken"]
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        
        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            print("에러가 발생했습니다 : \(error.localizedDescription)")
            completion(.doNotRetry)
            return
        }
        
        refreshAccessToken { success in
            if success {
                completion(.retry)
            } else {
                completion(.doNotRetry)
                NotificationCenter.default.post(name: .tokenExpired, object: nil)
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        
        guard let refreshToken = keychain["refreshToken"] else {
            completion(false)
            return
        }
        
        let parameter = refreshAccessTokenParameter(refreshToken: refreshToken)
        
        let url = URL(string: "https://www.voqal.today/tokens")!
        
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: AuthData.self) { response in
            switch response.result {
            case .success(let res):
                let accessToken = res.accessToken
                let refreshToken = res.refreshToken
                keychain["accessToken"] = accessToken
                keychain["refreshToken"] = refreshToken
                completion(true)
            case .failure(let err):
                print(err)
                completion(false)
            }
        }
        
    }
}
