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
}

struct DeleteReservationModel: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
