//
//  PasswordResetData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/29/24.
//

import Foundation

struct PasswordResetData: Decodable {
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
}
