//
//  HomeData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/13/24.
//

import Foundation

struct HomeData: Codable {
    let nickName: String?
    let email: String?
    let name: String?
    let phoneNum: String?
    let role: String?
    let status: Int
    
    let message: String?
    let error: [ErrorDetail]?
    let code: String?
}


