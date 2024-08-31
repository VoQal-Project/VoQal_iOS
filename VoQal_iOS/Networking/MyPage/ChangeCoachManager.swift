//
//  ChangeCoachManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/25/24.
//

import Foundation
import Alamofire

struct ChangeCoachParameter: Encodable {
    let coachId: Int
}

struct ChangeCoachManager {
    
    func getCoachList(completion: @escaping (ChangeCoachListModel?) -> Void) {
        let url = "https://www.voqal.today/role/coach"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: ChangeCoachListData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = ChangeCoachListModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func changeCoach(coachId: Int, completion: @escaping (ChangeCoachModel?) -> Void) {
        let url = "https://www.voqal.today/request"
        let parameter = ChangeCoachParameter(coachId: coachId)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: ChangeCoachData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let model = ChangeCoachModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
