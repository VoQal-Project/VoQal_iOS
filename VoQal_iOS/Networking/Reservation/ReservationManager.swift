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

struct ReservationParameter: Encodable {
    let roomId: Int
    let startTime: String
    let endTime: String
}

struct ReservationManager {
    
    private let fetchTimesUrl = "https://www.voqal.today/available-times"
    private let reservationUrl = "https://www.voqal.today/reservation"
    
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
    
    func makeReservation(_ roomId: Int, _ startTime: String, _ endTime: String, completion: @escaping (ReservationModel?) -> Void) {
        let parameter = ReservationParameter(roomId: roomId, startTime: startTime, endTime: endTime)
        print("Parameter : \(parameter)")
        AF.request(reservationUrl, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, interceptor: AuthInterceptor()).responseDecodable(of: ReservationData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let roomId = res.roomId
                let startTime = res.startTime
                let endTime = res.endTime
                let message = res.message
                let errors = res.errors
                let code = res.code
                let model = ReservationModel(roomId: roomId, startTime: startTime, endTime: endTime, message: message, status: status, errors: errors, code: code)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
    }
    
}
