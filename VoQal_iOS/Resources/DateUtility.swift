//
//  DateUtility.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/21/24.
//

import Foundation

class DateUtility {
    
    static func stringToDate(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter.date(from: date)
    }
    
    static func convertSelectedDate(_ date: Date, _ toSubmit: Bool) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = toSubmit ? "yyyy-MM-dd": "yy년 M월 d일"
        return formatter.string(from: date)
    }
    
    static func convertToISO8601String(date: Date, time: String) -> String? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        // 년월일
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        // 시분
        let timeComponents = time.split(separator: ":").compactMap { Int($0) }
        let hour = timeComponents[0]
        let minute = timeComponents[1]
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // DateComponents로 Date 객체 생성
        guard let fullDate = calendar.date(from: dateComponents) else { return nil }
        
        // Date 객체를 ISO8601 형식의 문자열로 변환
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.string(from: fullDate)
    }
    
    static func iSO8601timeRangeString(from startTime: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // 시작 시간을 Date 객체로 변환
        guard let startDate = inputFormatter.date(from: startTime) else {
            return nil
        }
        
        // Calendar를 사용하여 1시간 뒤의 시간을 계산
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        // 시작 시간과 끝 시간을 문자열로 변환
        let startTimeString = outputFormatter.string(from: startDate)
        let endTimeString = outputFormatter.string(from: endDate)
        let timeRange = "\(startTimeString)~\(endTimeString)"
        
        return timeRange
    }
    
    static func timeRangeString(from startTime: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        
        // 시작 시간을 Date 객체로 변환
        guard let startDate = inputFormatter.date(from: startTime) else {
            return nil
        }
        
        // Calendar를 사용하여 1시간 뒤의 시간을 계산
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        // 시작 시간과 끝 시간을 문자열로 변환
        let startTimeString = outputFormatter.string(from: startDate)
        let endTimeString = outputFormatter.string(from: endDate)
        let timeRange = "\(startTimeString)~\(endTimeString)"
        
        return timeRange
    }
    
    static func convertEndTimeString(from startTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // 시작 시간을 Date 객체로 변환
        guard let startDate = dateFormatter.date(from: startTime) else {
            return nil
        }
        
        // Calendar를 사용하여 1시간 뒤의 시간을 계산
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else {
            return nil
        }
        
        return dateFormatter.string(from: endDate)
    }
    
    static func convertStringToDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 원래 문자열의 형식
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd" // 변환할 형식
        
        guard let date = inputFormatter.date(from: dateString) else {
            print("convertStringToDate failed!")
            return ""
        }
        
        return outputFormatter.string(from: date)
    }
    
    static func convertToDateString(_ date: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let newDate = inputFormatter.date(from: date) else { return "error" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy년 M월 d일"
        
        return outputFormatter.string(from: newDate)
    }
}
