//
//  ChangeCoachData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/25/24.
//

import Foundation

struct ChangeCoachListData: Codable {
    let status: Int
    let data: [Coach]?
}

struct ChangeCoachData: Codable {
    let message: String
    let status: Int
}
