//
//  StudentLessonNoteManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation
import Alamofire

struct StudentLessonNoteManager {
    
    func fetchLessonNotes(completion: @escaping (StudentLessonNoteModel?) -> Void) {
        
        let url = "https://www.voqal.today/lessonNote/student"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: StudentLessonNoteData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let lessonNotes = res.data
                guard let lessonNotes = lessonNotes else { print("fetchLessonNotes - lessonNotes 바인딩 오류"); return }
                let model = StudentLessonNoteModel(status: status, data: lessonNotes)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
