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

struct StudentStatusData: Codable {
    let status: Int
    let message: String?
    let errors: [ErrorDetail]?
    let code: String?
    let data: StudentStatus?
    
}

struct StudentStatus: Codable {
    let status: String?
}

struct FetchFirebaseCustomTokenData: Codable {
    let firebaseCustomToken: String
    let status: Int
}
