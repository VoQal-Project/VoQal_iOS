//
//  CoachSelectionManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import Foundation
import Alamofire

struct applyCoachParameter: Encodable {
    let coachId: Int
}

struct CoachSelectionManager {
    private let getCoachUrl = "https://www.voqal.today/role/coach"
    private let applyCoachUrl = "https://www.voqal.today/request"
    
    func getCoachList(completion: @escaping (CoachSelectionModel?) -> Void) {
        AF.request(getCoachUrl, method: .get).responseDecodable(of: CoachSelectionData.self) { (response) in
            switch response.result{
            case .success(let res):
                let status = res.status
                let coaches = res.data
                let model = CoachSelectionModel(status: status, coaches: coaches)
                print(model)
                completion(model)
            case .failure(let err):
                completion(nil)
                print(err)
            }
        }
    }
    
    func applyCoach(_ coachId: Int, completion: @escaping (ApplyCoachModel?) -> Void) {
        
        let parameter = applyCoachParameter(coachId: coachId)
        
        AF.request(applyCoachUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: ApplyCoachData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let model = ApplyCoachModel(status: status, message: message)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
}

