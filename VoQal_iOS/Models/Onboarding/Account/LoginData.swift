//
//  LoginData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import Foundation

struct LoginData: Codable {
    let status: Int
    let accessToken: String?
    let refreshToken: String?
    let role: String?
    let message: String?
    let errors: [ErrorDetail]?
    let code: String?
}
