//
//  MyChallengePostModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation

struct MyChallengePostModel {
    let status: Int
    let data: [MyChallengePost]?
}

struct EditChallengePostModel {
    
}

struct DeleteChallengePostModel {
    let message: String
    let status: Int
}
