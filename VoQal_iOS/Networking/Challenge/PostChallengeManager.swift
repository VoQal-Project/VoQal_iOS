//
//  PostChallengeManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation
import Alamofire

struct PostChallengeParameter: Encodable {
    let songTitle: String
    let singer: String
}

struct PostChallengeManager {
    
    func encodeToJSONData<T: Encodable>(_ value: T) -> Data? {
        return try? JSONEncoder().encode(value)
    }
    
    
    func postChallenge(thumbnail: Data, thumbnailName: String, songTitle: String, singer: String, fileURL: URL, completion: @escaping (PostChallengeModel?) -> Void) {
        let url = "https://www.voqal.today/challenge"
        
        let createChallengeRequestDTO = PostChallengeParameter(songTitle: songTitle, singer: singer)
        
        // JSON 데이터를 인코딩
        guard let jsonData = try? JSONEncoder().encode(createChallengeRequestDTO) else {
            print("jsonData 인코딩 실패")
            completion(nil)
            return
        }
        
        // 파일 경로가 파일인지 확인
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
            print("파일이 존재하지 않거나 디렉토리입니다.")
            completion(nil)
            return
        }
        
        print("파일 경로: \(fileURL.path)")
        print("JSON 데이터: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // 썸네일 이미지 추가
                multipartFormData.append(thumbnail, withName: "thumbnail", fileName: "\(thumbnailName).png", mimeType: "image/png")
                
                // 레코드 파일 추가
                multipartFormData.append(fileURL, withName: "record", fileName: fileURL.lastPathComponent, mimeType: "audio/mpeg")
                
                // JSON 데이터 추가
                multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
            },
            to: url,
            method: .post,
            headers: [
                "accept": "application/json",
                "Content-Type": "multipart/form-data"
            ],
            interceptor: AuthInterceptor()
        )
        .validate() // 응답 검증
        .responseDecodable(of: PostChallengeData.self) { response in
            switch response.result {
            case .success(let res):
                print("서버 응답 성공: \(res)")
                let status = res.status
                let message = res.message
                let code = res.code
                let errors = res.errors
                let model = PostChallengeModel(message: message, status: status, errors: errors, code: code)
                completion(model)
            case .failure(let err):
                if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                    print("서버 응답 오류: \(errorString)")
                } else {
                    print("알 수 없는 서버 오류: \(err)")
                }
                completion(nil)
            }
        }
    }
    
    
    
    
    
    //    func postChallenge( thumbnail: Data, thumbnailName: String , songTitle: String, singer: String, fileURL: URL, completion: @escaping (PostChallengeModel?) -> Void) {
    //        let url = "https://www.voqal.today/challenge"
    //
    //        let postChallengeParameter = PostChallengeParameter(songTitle: songTitle, singer: singer)
    //
    ////        let jsonObject: [String: String] = [
    ////                "songTitle": songTitle,
    ////                "singer": singer
    ////            ]
    //
    ////        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
    ////              let jsonString = String(data: jsonData, encoding: .utf8) else {
    ////            completion(nil)
    ////            return
    ////        }
    //
    //        guard let jsonData = encodeToJSONData(postChallengeParameter) else { print("jsonData 인코딩 실패"); return }
    //
    //        // 파일 경로가 파일인지 확인
    //        var isDirectory: ObjCBool = false
    //        guard FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
    //            print("파일이 존재하지 않거나 디렉토리입니다.")
    //            completion(nil)
    //            return
    //        }
    //
    //        print("파일 경로: \(fileURL.path)")
    //        print("JSON 데이터: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
    //
    //        AF.upload(
    //            multipartFormData: { multipartFormData in
    //                // 썸네일 이미지 추가
    //                multipartFormData.append(thumbnail, withName: "thumbnail", fileName: "\(thumbnailName).png", mimeType: "image/png")
    //
    //                // 레코드 파일 추가
    //                multipartFormData.append(fileURL, withName: "record", fileName: fileURL.lastPathComponent, mimeType: "audio/mpeg")
    //
    //                // JSON 데이터 추가
    //                multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
    //            },
    //            to: url,
    //            method: .post,
    //            headers: [
    //                "accept": "application/json",
    //                "Content-Type": "multipart/form-data"
    //            ]
    //            , interceptor: AuthInterceptor()
    //        )
    //        .validate() // 응답 검증
    //        .responseDecodable(of: PostChallengeData.self) { response in
    //            switch response.result {
    //            case .success(let res):
    //                print("서버 응답 성공: \(res)")
    //                let status = res.status
    //                let message = res.message
    //                let code = res.code
    //                let errors = res.errors
    //                let model = PostChallengeModel(message: message, status: status, errors: errors, code: code)
    //                completion(model)
    //            case .failure(let err):
    //                if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
    //                    print("서버 응답 오류: \(errorString)")
    //                } else {
    //                    print("알 수 없는 서버 오류: \(err)")
    //                }
    //                completion(nil)
    //            }
    //        }
    //    }
}
