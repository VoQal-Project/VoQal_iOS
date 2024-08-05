//
//  StudentRecordFileManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation
import Alamofire
import AVFoundation

struct StudentRecordFileManager {
    
    func fetchRecordFiles(completion: @escaping (StudentRecordFileModel?) -> Void) {
        
        let url = "https://www.voqal.today/record/student"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: StudentRecordFileData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let data = res.data
                let status = res.status
                let model = StudentRecordFileModel(status: status, data: data)
                
                Task {
                    await model.loadDurations {
                        completion(model)
                    }
                }
                
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func getAudioDuration(from url: URL) async throws -> TimeInterval? {
        
        let asset = AVURLAsset(url: url)
        
        do {
            let duration = try await asset.load(.duration)
            let durationInSeconds = CMTimeGetSeconds(duration)
            return durationInSeconds
        } catch {
            print("Failed to load duration: \(error)")
            return nil
        }
    }
}
