//
//  RegistrationData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/27/24.
//

import Foundation

struct RegistrationData: Codable {
    let nickName: String?
    let email: String?
    let name: String?
    let phoneNum: String?
    let status: Int
    let message: String?
    let error: ErrorDetail?
    let code: String?
}


