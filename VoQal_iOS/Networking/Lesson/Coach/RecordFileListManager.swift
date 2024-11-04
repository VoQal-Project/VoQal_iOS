//
//  RecordFileListManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import Foundation
import Alamofire

struct RecordFileListManager {
    
    func fetchRecordFileList(_ studentId: Int, completion: @escaping (RecordFileListModel?) -> Void) {
        let url = "https://www.voqal.today/record?studentId=\(studentId)"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: RecordFileListData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = RecordFileListModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func deleteRecordFile(_ recordId: Int64, completion: @escaping (DeleteRecordFileModel?) -> Void) {
        let url = "https://www.voqal.today/lessonNote/\(recordId)"
        
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: DeleteRecordFileData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let message = res.message
                let model = DeleteRecordFileModel(message: message, status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
