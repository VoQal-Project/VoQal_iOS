//
//  ManageStudentManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import Foundation
import Alamofire

struct ManageStudentManager {
    
    private let fetchUrl = "https://www.voqal.today/student"
    private let lessonSongUrl = "https://www.voqal.today/lessonsongurl"
    
    func getStudents(completion: @escaping (ManageStudentModel?) -> Void) {
        
        AF.request(fetchUrl, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: ManageStudentData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let students = res.data
                guard let students = students else { print("students를 불러오는 데에 실패했습니다."); return }
                let model = ManageStudentModel(status: status, students: students)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func deleteStudent(_ studentId: Int, completion: @escaping (DeleteStudentModel?) -> Void) {
        let url = "https://www.voqal.today/\(Int64(studentId))"
        
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: DeleteStudentData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let code = res.code
                let errors = res.errors
                let model = DeleteStudentModel(message: message, status: status, errors: errors, code: code)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
