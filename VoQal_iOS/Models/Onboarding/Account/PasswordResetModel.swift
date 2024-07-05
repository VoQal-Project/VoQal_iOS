//
//  PasswordResetModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/3/24.
//

import Foundation

struct PasswordResetModel: Decodable {
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
}
