//
//  CoachSelectionManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import Foundation
import Alamofire

struct CoachSelectionManager {
    private let url = "https://www.voqal.today/role/coach"
    
    func getCoachList(completion: @escaping (CoachSelectionModel?) -> Void) {
        AF.request(url, method: .get).responseDecodable(of: CoachSelectionData.self) { (response) in
            switch response.result{
            case .success(let res):
                let status = res.status
                let coaches = res.data
                let model = CoachSelectionModel(status: status, coaches: coaches)
                print(model)
                completion(model)
            case .failure(let err):
                completion(nil)
                print(err)
            }
        }
    }
}

