//
//  HomeModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/13/24.
//

import Foundation

struct HomeSuccessModel: Codable {
    let nickname: String?
    let email: String?
    let name: String?
    let phoneNum: String?
    let role: String?
    let status: Int
}

struct HomeErrorModel: Codable {
    let status: Int
    let message: String?
    let error: [ErrorDetail]?
    let code: String?
}

struct HomeModel {
    let successModel: HomeSuccessModel?
    let errorModel: HomeErrorModel?
}
