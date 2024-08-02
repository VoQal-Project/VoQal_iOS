//
//  StudentRecordFileManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation
import Alamofire

struct StudentRecordFileManager {
    
    func fetchRecordFiles(completion: @escaping (StudentRecordFileModel?) -> Void) {
        
        let url = "https://www.voqal.today/lessonNote/student"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: StudentRecordFileData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
}
