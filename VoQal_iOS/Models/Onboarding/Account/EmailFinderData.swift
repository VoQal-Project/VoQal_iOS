//
//  EmailFinderData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/28/24.
//

import Foundation

struct EmailFinderData: Decodable {
    let email: String?
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
}

struct ErrorDetail: Decodable {
    let field: String
    let value: String
    let reason: String
}
