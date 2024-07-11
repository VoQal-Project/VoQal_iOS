//
//  CoachSelectionData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import Foundation

struct CoachSelectionData: Codable {
    let status: Int
    let data: [Coach]?
}

struct Coach: Codable {
    let id: Int
    let name: String
}
