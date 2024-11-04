//
//  LessonNoteListManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import Foundation
import Alamofire

struct LessonNoteListManager {
    
    func fetchLessonNoteList(_ studentId: Int, completion: @escaping (LessonNoteListModel?) -> Void) {
        let url = "https://www.voqal.today/lessonNote?studentId=\(studentId)"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: LessonNoteListData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = LessonNoteListModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func deleteLessonNote(_ lessonNoteId: Int64, completion: @escaping (DeleteLessonNoteModel?) -> Void) {
        let url = "https://www.voqal.today/lessonNote/\(lessonNoteId)"
        
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: DeleteLessonNoteData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let model = DeleteLessonNoteModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
