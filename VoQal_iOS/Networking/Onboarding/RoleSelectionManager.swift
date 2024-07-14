//
//  RoleSelectionManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/9/24.
//

import Foundation
import Alamofire

struct RoleSelectionManager {
    
    private let setCoachUrl = "https://www.voqal.today/role/coach"
    
    func setCoach(completion: @escaping (RoleSelectionModel?) -> Void) {
        AF.request(setCoachUrl, method: .post, interceptor: AuthInterceptor()).responseDecodable(of: RoleSelectionData.self) { response in
            switch response.result {
            case .success(let res):
                let accessToken = res.accessToken
                let refreshToken = res.refreshToken
                let status = res.status
                let model = RoleSelectionModel(accessToken: accessToken, refreshToken: refreshToken, status: status)
                
                if let accessToken = accessToken, let refreshToken = refreshToken {
                    KeychainHelper.shared.saveAccessToken(accessToken)
                    KeychainHelper.shared.saveRefreshToken(refreshToken)
                } else {print("Token 저장 실패")}
                
                completion(model)
            case .failure(let err):
                print("setCoach 에러 : \(err)")
                completion(nil)
            }
        }
    }
    
    
    
}
