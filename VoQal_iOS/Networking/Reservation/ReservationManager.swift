//
//  ReservationManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/18/24.
//

import Foundation
import Alamofire

struct FetchTimesParameter: Encodable {
    let roomId: Int
    let requestDate: String
}

struct ReservationManager {
    
    private let fetchTimesUrl = "https://www.voqal.today/available-times"
    
    func fetchTimes(_ roomId: Int, _ requestDate: Date, completion: @escaping (FetchTimesModel?) -> Void) {
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let requestDateString = dateFormatter.string(from: requestDate)
        let parameter = FetchTimesParameter(roomId: roomId, requestDate: requestDateString)
        
        AF.request(fetchTimesUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: FetchTimesData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let roomId = res.roomId
                let availableTimes = res.availableTimes
                if let roomId = roomId, let availableTimes = availableTimes {
                    let model = FetchTimesModel(roomId: roomId, availableTimes: availableTimes, message: res.message, status: res.status, errors: res.errors, code: res.code)
                    completion(model)
                }
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}
