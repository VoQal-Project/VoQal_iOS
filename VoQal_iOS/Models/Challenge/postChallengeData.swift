//
//  postChallengeData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation

struct postChallengeData: Codable {
    let message: String
    let status: Int
    let errors: [ErrorDetail]?
    let code: String?
}
