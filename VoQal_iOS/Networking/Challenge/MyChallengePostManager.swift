//
//  MyChallengePostManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation
import Alamofire

struct MyChallengePostManager {
    
    func fetchMyChallengePosts(completion: @escaping (MyChallengePostModel?) -> Void) {
        let url = "https://www.voqal.today/challenge/my"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: MyChallengePostData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                if let data = res.data {
                    let model = MyChallengePostModel(status: status, data: data)
                    completion(model)
                }
                else {
                    print("fetchMyChallengePosts - data 바인딩 실패")
                    completion(nil)
                }
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func downloadThumbnailImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        AF.download(url).responseData { response in
            switch response.result {
            case .success(let data):
                guard let thumbnailImage = UIImage(data: data) else {
                    print("thumbnailImage to UIImage 실패")
                    completion(nil)
                    return
                }
                print("manager - downloadThumbnailImage: \(thumbnailImage)")
                completion(thumbnailImage)
            case .failure(let err):
                print("Error downloading image: \(err)")
                completion(nil)
            }
        }
    }
    
}
