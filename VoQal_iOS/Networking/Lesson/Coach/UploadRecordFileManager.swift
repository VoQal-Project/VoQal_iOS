//
//  UploadRecordFileManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/29/24.
//

import Foundation
import Alamofire

struct UploadRequest: Encodable {
    let studentId: Int
    let recordDate: String
    let recordTitle: String
}

struct UploadRecordFileManager {

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
                // 파일 추가 (파일 이름을 명시적으로 지정)
                multipartFormData.append(fileURL, withName: "recordFile", fileName: fileURL.lastPathComponent, mimeType: "audio/mpeg")
                
                // JSON 데이터 추가
                multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
            },
            to: url,
            method: .post,
            headers: [
                "accept": "application/json",
                "Content-Type": "multipart/form-data"
            ]
            , interceptor: AuthInterceptor()
        )
        .validate() // 응답 검증
        .responseDecodable(of: UploadRecordFileData.self) { response in
            switch response.result {
            case .success(let res):
                print("서버 응답 성공: \(res)")
                let status = res.status
                let message = res.message
                let code = res.code
                let errors = res.errors
                let data = res.data
                let model = UploadRecordFileModel(status: status, message: message, errors: errors, code: code, data: data)
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
