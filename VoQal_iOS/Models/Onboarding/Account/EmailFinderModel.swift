//
//  EmailFinderModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/28/24.
//

import Foundation

struct EmailFinderModel: Decodable {
    let email: String?
    let message: String?
    let status: Int?
    let errors: [ErrorDetail]?
    let code: String?
}
