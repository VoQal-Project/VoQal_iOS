//
//  Extension.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/18.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension Notification.Name {
    static let tokenExpired = Notification.Name("tokenExpired")
}

extension UIButton {
    
    private static var throttleTime: [String: Date] = [:]
    
    func throttle(seconds: Double, action: @escaping () -> Void) {
        // 버튼의 메모리 주소를 고유 식별자로 사용
        let identifier = String(describing: self)
        
        // 현재 시간
        let now = Date()
        
        // 마지막으로 액션이 실행된 시간을 가져옴
        if let lastExecutionTime = UIButton.throttleTime[identifier] {
            // 마지막 실행 시간과 현재 시간의 차이를 계산
            let timePassed = now.timeIntervalSince(lastExecutionTime)
            
            // 설정된 쓰로틀링 시간이 지나지 않았다면 액션을 실행하지 않음
            guard timePassed >= seconds else { return }
        }
        
        // 현재 시간을 마지막 실행 시간으로 저장
        UIButton.throttleTime[identifier] = now
        
        // 액션 실행
        action()
    }
    
}

extension UIBarButtonItem {
    // 쓰로틀링 상태를 저장할 속성
    private static var throttleTime: [String: Date] = [:]
    
    /// UIBarButtonItem에 쓰로틀링을 적용하는 메서드
    /// - Parameters:
    ///   - seconds: 쓰로틀링 시간 (초)
    ///   - action: 실행할 액션
    func throttle(seconds: Double, action: @escaping () -> Void) {
        // 버튼의 메모리 주소를 고유 식별자로 사용
        let identifier = String(describing: self)
        
        // 현재 시간
        let now = Date()
        
        // 마지막으로 액션이 실행된 시간을 가져옴
        if let lastExecutionTime = UIBarButtonItem.throttleTime[identifier] {
            // 마지막 실행 시간과 현재 시간의 차이를 계산
            let timePassed = now.timeIntervalSince(lastExecutionTime)
            
            // 설정된 쓰로틀링 시간이 지나지 않았다면 액션을 실행하지 않음
            guard timePassed >= seconds else { return }
        }
        
        // 현재 시간을 마지막 실행 시간으로 저장
        UIBarButtonItem.throttleTime[identifier] = now
        
        // 액션 실행
        action()
    }
}
