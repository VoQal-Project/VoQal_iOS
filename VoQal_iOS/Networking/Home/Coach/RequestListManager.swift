//
//  RequestListManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import Foundation
import Alamofire

struct RequestListManager {
    
    let url = "https://www.voqal.today/request"
    
    func getRequestStudentList(completion: @escaping (RequestListModel?) -> Void) {
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: RequestListData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let students = res.data
                let status = res.status
                if let status = status {
                    let model = RequestListModel(status: status, students: students)
                    completion(model)
                } else {
                    print("status를 받아오지 못했습니다. (getRequestStudentList)")
                }
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
        
    }
    
}

