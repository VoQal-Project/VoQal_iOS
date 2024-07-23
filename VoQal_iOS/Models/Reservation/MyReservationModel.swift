//
//  MyReservationModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/21/24.
//

import Foundation

struct MyReservationModel {
    let status: Int
    let data: [Reservation]
    
    var sortedData: [Reservation] {
        data.sorted { firstReservation, secondReservation in
            guard let firstDate = DateUtility.stringToDate(firstReservation.startTime),
                  let secondDate = DateUtility.stringToDate(secondReservation.startTime) else {
                return false
            }
            return firstDate < secondDate
        }
    }
}

struct DeleteReservationModel: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
