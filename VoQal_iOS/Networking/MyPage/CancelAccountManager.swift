//
//  CancelAccountManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/23/24.
//

import Foundation
import Alamofire

struct CancelAccountManager {
    
    let url = "https://www.voqal.today/delete/member"
    
    func cancelAccount(completion: @escaping (CancelAccountModel?) -> Void) {
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: CancelAccountData.self) { response in
            switch response.result {
            case .success(let res):
                let message = res.message
                let status = res.status
                let model = CancelAccountModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}
