//
//  FCMTokenManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 10/23/24.
//

import Foundation
import Alamofire

struct SendFCMTokenParameter: Encodable {
    let userId: String
    let fcmToken: String
}

struct FCMTokenManager {
    
    func sendFCMToken(_ userId: String, _ fcmToken: String, completion: @escaping (FCMTokenModel?) -> Void) {
        let url = "https://www.voqal.today/fcm/token"
        let parameter = SendFCMTokenParameter(userId: userId, fcmToken: fcmToken)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: FCMTokenData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let model = FCMTokenModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}
