//
//  MyLikePostChallengePostManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/27/24.
//

import Foundation
import Alamofire

struct MyLikeChallengePostManager {
    
    func fetchMyLikePost(completion: @escaping (MyLikePostModel?) -> Void) {
        let url = "https://www.voqal.today/liked"
        
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: MyLikePostData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                guard let data = res.data else { print("fetchMyLikePost  - data is nil"); return }
                let model = MyLikePostModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}
