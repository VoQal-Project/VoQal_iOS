//
//  EditLessonNoteManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/12/24.
//

import Foundation
import Alamofire

struct EditLessonNoteParameter: Encodable {
    let updateSongTitle: String
    let updateLessonNoteTitle: String
    let updateContents: String
    let updateSinger: String
    let updateLessonDate: String
}

struct EditLessonNoteManager {
    
    func fetchLessonNote(_ lessonNoteId: Int64, completion: @escaping (LessonNoteDetailModel?) -> Void) {
        
        let url = "https://www.voqal.today/lessonNote/\(lessonNoteId)"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: LessonNoteDetailData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                guard let data = res.data, let status = res.status else { print("data or status is nil"); return }
                let model = LessonNoteDetailModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
    func editLessonNote(title: String, songTitle: String, contents: String, singer: String, lessonDate: String, lessonNoteId: Int64, completion: @escaping (EditLessonNoteModel?) -> Void) {
        
        let url = "https://www.voqal.today/lessonNote/\(lessonNoteId)"
        let editLessonNoteParameter = EditLessonNoteParameter(updateSongTitle: songTitle, updateLessonNoteTitle: title, updateContents: contents, updateSinger: singer, updateLessonDate: lessonDate)
        
        AF.request(url, method: .patch, parameters: editLessonNoteParameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: EditLessonNoteData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let message = res.message
                let status = res.status
                let model = EditLessonNoteModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
