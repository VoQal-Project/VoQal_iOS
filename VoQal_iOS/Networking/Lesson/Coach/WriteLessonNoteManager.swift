//
//  WriteLessonNoteManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/24/24.
//

import Foundation
import Alamofire

struct WriteLessonNoteParameter: Encodable {
    let studentId: Int
    let songTitle: String
    let lessonNoteTitle: String
    let contents: String
    let singer: String
    let lessonDate: String
}

struct WriteLessonNoteManager {
    
    func writeLessonNote(_ studentId: Int, _ songTitle: String, _ lessonNoteTitle: String, _ contents: String, _ singer: String, _ lessonDate: String, completion: @escaping (WriteLessonNoteModel?) -> Void) {
        let url = "https://www.voqal.today/create/note"
        let parameter = WriteLessonNoteParameter(studentId: studentId, songTitle: songTitle, lessonNoteTitle: lessonNoteTitle, contents: contents, singer: singer, lessonDate: lessonDate)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: WriteLessonNoteData.self) { response in
            switch response.result {
            case .success(let res):
                print("parameter: \(parameter)")
                print(res)
                let status = res.status
                let message = res.message
                let errors = res.errors
                let code = res.code
                let model = WriteLessonNoteModel(message: message, status: status, errors: errors, code: code)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    
    
}


