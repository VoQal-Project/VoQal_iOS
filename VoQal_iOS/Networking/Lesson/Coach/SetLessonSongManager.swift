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

struct SetLessonSongManager {
    
    private let url = "https://www.voqal.today/lessonsongurl"
    
    func setLessonSong(_ studentId: Int, _ lessonSongUrl: String, _ singer: String, _ songTitle: String, completion: @escaping (SetLessonSongModel?) -> Void) {
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
    
}
