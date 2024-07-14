//
//  HomeManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/13/24.
//

import Foundation
import Alamofire

struct HomeManager {
    private let url = "https://www.voqal.today/user/details"
    
    func getUserInform(completion: @escaping (HomeModel?) -> Void) {
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: HomeData.self) { response in
            switch response.result {
            case .success(let res):
                if (200...299).contains(res.status) {
                    let successModel = HomeSuccessModel(nickname: res.nickName,
                                                 email: res.email,
                                                 name: res.name,
                                                 phoneNum: res.phoneNum,
                                                 role: res.role,
                                                 status: res.status)
                    let model = HomeModel(successModel: successModel, errorModel: nil)
                    completion(model)
                } else {
                    let errorModel = HomeErrorModel(status: res.status,
                                                    message: res.message,
                                                    error: res.error,
                                                    code: res.code)
                    let model = HomeModel(successModel: nil, errorModel: errorModel)
                    completion(model)
                }
            case .failure(let err):
                print("유저 디테일 받아오기 실패: \(err)")
                completion(nil)
            }
        }
    }
}
