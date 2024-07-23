//
//  ReservationModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/18/24.
//

import Foundation

struct ReservationModel {
    let roomId: Int?
    let startTime: String?
    let endTime: String?
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
}

struct FetchTimesModel {
    let roomId: Int
    let availableTimes: [String]
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
    
    var convertedAvailableTimes: [String] {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        
        return availableTimes.compactMap { timeString in
            if let date = dateFormatter.date(from: timeString){
                return formatter.string(from: date)
            } else {
                print("Failed to convert")
                return nil
            }
            
        }
    }
}

struct EditReservationModel {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
