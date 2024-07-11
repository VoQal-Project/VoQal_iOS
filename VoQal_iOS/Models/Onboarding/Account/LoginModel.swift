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
    let code: String? = ""
}
