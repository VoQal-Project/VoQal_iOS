//
//  EditChallengeManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/7/24.
//

import Foundation
import Alamofire

struct EditChallengeParameter: Encodable {
    let songTitle: String
    let singer: String
}

struct EditChallengeManager {
    
    func encodeToJSONData<T: Encodable>(_ value: T) -> Data? {
        return try? JSONEncoder().encode(value)
    }
    
    
    func editChallenge(thumbnail: Data?, thumbnailName: String?, songTitle: String, singer: String, fileURL: URL?, challengePostId: Int64, completion: @escaping (EditChallengeModel?) -> Void) {
        let url = "https://www.voqal.today/challenge/\(challengePostId)"
        
        let editChallengeRequestDTO = EditChallengeParameter(songTitle: songTitle, singer: singer)
        
        if thumbnail == nil {
            
        }
        
        // JSON 데이터를 인코딩
        guard let jsonData = try? JSONEncoder().encode(editChallengeRequestDTO) else {
            print("jsonData 인코딩 실패")
            completion(nil)
            return
        }
        
        // 파일 경로가 파일인지 확인
        var isDirectory: ObjCBool = false
        
        if let fileURL = fileURL {
            guard FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory), !isDirectory.boolValue else {
                print("파일이 존재하지 않거나 디렉토리입니다.")
                completion(nil)
                return
            }
        }
        
        print("JSON 데이터: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // 썸네일 이미지 추가
                if let thumbnail = thumbnail, let thumbnailName = thumbnailName {
                    multipartFormData.append(thumbnail, withName: "thumbnail", fileName: "\(thumbnailName).png", mimeType: "image/png")
                }
                
                // 녹음 파일이 있으면 추가
                if let fileURL = fileURL {
                    multipartFormData.append(fileURL, withName: "record", fileName: fileURL.lastPathComponent, mimeType: "audio/mpeg")
                }
                
                // JSON 데이터 추가
                multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
            },
            to: url,
            method: .patch,
            headers: [
                "accept": "application/json",
                "Content-Type": "multipart/form-data"
            ],
            interceptor: AuthInterceptor()
        )
        .validate() // 응답 검증
        .responseDecodable(of: EditChallengeData.self) { response in
            switch response.result {
            case .success(let res):
                print("서버 응답 성공: \(res)")
                let status = res.status
                let message = res.message
                let model = EditChallengeModel(message: message, status: status)
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
    
}
