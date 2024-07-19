//
//  ReservationData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/18/24.
//

import Foundation

struct ReservationData: Codable {
    let roomId: Int?
    let startTime: String?
    let endTime: String?
    let message: String?
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}

struct FetchTimesData: Codable {
    let roomId: Int?
    let availableTimes: [String]? // 10am~10pm
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
}
