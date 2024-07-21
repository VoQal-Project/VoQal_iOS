//
//  MyReservationData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/21/24.
//

import Foundation

struct MyReservationData: Codable {
    let message: String?
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
    let data: [Reservation]?
}

struct Reservation: Codable {
    let roomId: Int
    let reservationId: Int
    let startTime: String
    let endTime: String
}

struct DeleteReservationData: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
