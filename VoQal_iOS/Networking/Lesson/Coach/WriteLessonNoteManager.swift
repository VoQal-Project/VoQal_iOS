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

struct UploadRequest: Encodable {
    let studentId: Int
    let recordDate: String
    let recordTitle: String
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
    
    func encodeToJSONData<T: Encodable>(_ value: T) -> Data? {
        return try? JSONEncoder().encode(value)
    }
    
    func uploadRecordFile(studentId: Int, recordDate: String, recordTitle: String, fileURL: URL, completion: @escaping (UploadRecordFileModel?) -> Void) {
        let url = "https://www.voqal.today/create/record"
        
        let uploadRequest = UploadRequest(studentId: studentId, recordDate: recordDate, recordTitle: recordTitle)
        
        guard let jsonData = encodeToJSONData(uploadRequest) else {
            completion(nil)
            return
        }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // 파일 추가
                multipartFormData.append(fileURL, withName: "recordFile")
                
                // JSON 데이터 추가
                multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
            },
            to: url,
            method: .post
        )
        .validate() // 응답 검증
        .responseDecodable(of: UploadRecordFileData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let code = res.code
                let errors = res.errors
                let data = res.data
                let model = UploadRecordFileModel(status: status, message: message, errors: errors, code: code, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}


