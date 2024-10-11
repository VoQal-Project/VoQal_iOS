//
//  SetLessonSongManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/28/24.
//

import Foundation
import Alamofire

struct SetLessonSongParameter: Encodable {
    let studentId: Int
    let lessonSongUrl: String
    let singer: String
    let songTitle: String
}

struct EditLessonSongParameter: Encodable {
    let lessonSongUrl: String
    let singer: String
    let songTitle: String
}

struct SetLessonSongManager {
    
    func setLessonSong(_ studentId: Int, _ lessonSongUrl: String, _ singer: String, _ songTitle: String, completion: @escaping (SetLessonSongModel?) -> Void) {
        let url = "https://www.voqal.today/lessonsongurl"
        let parameter = SetLessonSongParameter(studentId: studentId, lessonSongUrl: lessonSongUrl, singer: singer, songTitle: songTitle)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: SetLessonSongData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let lessonSongUrl = res.lessonSongUrl
                let singer = res.singer
                let songTitle = res.songTitle
                let message = res.message
                let code = res.code
                let errors = res.errors
                let model = SetLessonSongModel(status: status, lessonSongUrl: lessonSongUrl, singer: singer, songTitle: songTitle, message: message, code: code, errors: errors)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func deleteLessonSong(_ studentId: Int64, completion: @escaping (DeleteLessonSongModel?) -> Void) {
        let url = "https://www.voqal.today/lessonsongurl/\(studentId)"
        
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: DeleteLessonSongData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let model = DeleteLessonSongModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Error Response Data: \(errorMessage)")
                }
                print("Error: \(err.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func editLessonSong(_ studentId: Int64, _ lessonSongUrl: String, _ singer: String, _ songTitle: String, completion: @escaping (EditLessonSongModel?) -> Void) {
        let url = "https://www.voqal.today/lessonsongurl/\(studentId)"
        let parameter = EditLessonSongParameter(lessonSongUrl: lessonSongUrl, singer: singer, songTitle: songTitle)
        
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: EditLessonSongData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let model = EditLessonSongModel(status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}
