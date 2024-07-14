//
//  AuthData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/12/24.
//

import Foundation

struct AuthData: Codable {
    let accessToken: String?
    let refreshToken: String?
    let status: Int
}
