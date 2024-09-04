//
//  ChallengeModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/15/24.
//

import Foundation
import UIKit

struct ChallengeModel {
    let status: Int
    let data: [ChallengePost]?
}

struct ChallengeLikeModel {
    let status: Int
}

struct ChallengeUnlikeModel {
    let status: Int
}

struct ChallengeKeywordModel {
    let keyword: String
    let color: String
}
