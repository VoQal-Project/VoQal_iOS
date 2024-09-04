//
//  ChallengeManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation
import Alamofire

struct ChallengeManager {
    
    func fetchChallengePosts( page: Int32, size: Int32, completion: @escaping (ChallengeModel?) -> Void) {
        
        let url = "https://www.voqal.today/challenge?page=\(page)&size=\(size)"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: ChallengeData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let data = res.data
                let model = ChallengeModel(status: status, data: data)
                completion(model)
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
    
    func likeChallengePost(_ challengePostId: Int64, completion: @escaping (ChallengeLikeModel?) -> Void) {
        let url = "https://www.voqal.today/\(challengePostId)/like"
        
        AF.request(url, method: .post, interceptor: AuthInterceptor()).responseDecodable(of: ChallengeLikeData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let model = ChallengeLikeModel(status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func unlikeChallengePost(_ challengePostId: Int64, completion: @escaping (ChallengeUnlikeModel?) -> Void) {
        let url = "https://www.voqal.today/\(challengePostId)/unlike"
        
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: ChallengeUnlikeData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let model = ChallengeUnlikeModel(status: status)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func fetchKeyword(completion: @escaping (ChallengeKeywordModel?) -> Void) {
        let url = "https://www.voqal.today/challenge/keyword"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: ChallengeKeywordData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                if let keyword = res.keyword,
                   let color = res.color {
                    let model = ChallengeKeywordModel(keyword: keyword, color: color)
                    completion(model)
                } else {
                    print("keyword or color is nil")
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
