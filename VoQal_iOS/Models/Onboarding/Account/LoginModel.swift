//
//  LoginModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import Foundation

struct LoginModel {
    let status: Int
    let message: String? = ""
    let errors: [ErrorDetail]? = nil
    let accessToken: String?
    let refreshToken: String?
    let role: String?
    let code: String? = ""
}

struct StudentStatusModel {
    let status: Int
    let message: String?
    let errors: [ErrorDetail]?
    let code: String?
    let data: StudentStatus?
}

struct FetchFirebaseCustomTokenModel {
    let firebaseCustomToken: String
    let status: Int
}
