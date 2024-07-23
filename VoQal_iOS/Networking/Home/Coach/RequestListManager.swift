//
//  RequestListManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import Foundation
import Alamofire

struct studentProcessParameter: Encodable {
    let studentId: Int
}

struct RequestListManager {
    
    let requestStudentsListUrl = "https://www.voqal.today/request"
    let approveStudentUrl = "https://www.voqal.today/approve"
    let rejectStudentUrl = "https://www.voqal.today/reject"
    
    func getRequestStudentList(completion: @escaping (RequestListModel?) -> Void) {
        
        AF.request(requestStudentsListUrl, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: RequestListData.self) { response in
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
    
    func approveStudent(_ studentId: Int, completion: @escaping (ApproveStudentModel?) -> Void) {
        let parameter = studentProcessParameter(studentId: studentId)
        AF.request(approveStudentUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: ApproveStudentData.self) { response in
            switch response.result {
            case .success(let res):
                let message = res.message
                let status = res.status
                let errors = res.errors
                let code = res.code
                let model = ApproveStudentModel(message: message, status: status, errors: errors, code: code)
                completion(model)
                print(res)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func rejectStudent(_ studentId: Int, completion: @escaping (RejectStudentModel?) -> Void) {
        let parameter = studentProcessParameter(studentId: studentId)
        AF.request(rejectStudentUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: RejectStudentData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let errors = res.errors
                let code = res.code
                let model = RejectStudentModel(message: message, status: status, errors: errors, code: code)
                completion(model)
                print(res)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}

