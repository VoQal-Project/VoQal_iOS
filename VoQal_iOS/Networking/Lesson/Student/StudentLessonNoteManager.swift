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
    
    func getLessonNoteDetail(_ lessonNoteId: Int, completion: @escaping (LessonNoteDetailModel?) -> Void) {
        
        let url = "https://www.voqal.today/lessonNote/\(lessonNoteId)"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: LessonNoteDetailData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                
                if let data = res.data,
                    let status = res.status {
                    let model = LessonNoteDetailModel(status: status, data: data)
                    completion(model)
                }
                else {
                    print("getLessonNoteDetail - 바인딩 오류")
                    completion(nil)
                }
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
//    func getLessonNoteDetail(_ lessonNoteId: Int, completion: @escaping (LessonNoteDetailModel?) -> Void) {
//        let url = "https://www.voqal.today/lessonNote/\(lessonNoteId)"
//        
//        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: LessonNoteDetailData.self) { response in
//            switch response.result {
//            case .success(let res):
//                print("url: \(url)")
//                print("Server response: \(res)")
//                
//                let lessonNoteTitle = res.lessonNoteTitle
//                let singer = res.singer
//                let songTitle = res.songTitle
//                let contents = res.contents
//                let lessonDate = res.lessonDate
//                let status = res.status
//                
//                let model = LessonNoteDetailModel(songTitle: songTitle ?? "", lessonNoteTitle: lessonNoteTitle ?? "", contents: contents ?? "", singer: singer ?? "", lessonDate: lessonDate ?? "", status: status)
//                completion(model)
//            case .failure(let err):
//                print("Failed to decode JSON: \(err)")
//                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
//                    print("Server response data: \(jsonString)")
//                }
//                completion(nil)
//            }
//        }
//    }
    
}
