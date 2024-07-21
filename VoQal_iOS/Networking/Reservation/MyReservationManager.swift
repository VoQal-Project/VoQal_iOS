//
//  MyReservationManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/21/24.
//

import Foundation
import Alamofire

struct MyReservationManager {
    
    private let reservationUrl = "https://www.voqal.today/reservation"
    
    
    func getMyReservations(completion: @escaping (MyReservationModel?) -> Void) {
        AF.request(reservationUrl, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: MyReservationData.self) { response in
            switch response.result {
            case .success(let res):
                let status = res.status
                let data = res.data
                guard let data = data else {print("예약 리스트를 받아오는 데에 실패했습니다."); return}
                let model = MyReservationModel(status: status, data: data)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
    func deleteMyReservation(_ reservationId: Int, completion: @escaping (DeleteReservationModel?) -> Void) {
        let convertedReservationId = Int64(reservationId)
        let url = "\(reservationUrl)/\(convertedReservationId)"
        
        print(url)
        
        AF.request(url, method: .delete, interceptor: AuthInterceptor()).responseDecodable(of: DeleteReservationData.self) { response in
            switch response.result {
            case .success(let res):
                print(res)
                let status = res.status
                let code = res.code
                let message = res.message
                let errors = res.errors
                let model = DeleteReservationModel(message: message, status: status, errors: errors, code: code)
                completion(model)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
}
