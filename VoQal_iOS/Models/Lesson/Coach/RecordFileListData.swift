//
//  RecordFileListData.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import Foundation

struct RecordFileListData: Codable {
    let status: Int
    let data: [RecordFile]?
}

struct RecordFile: Codable {
    let recordId: Int
    let recordDate: String
    let recordTitle: String
    let s3Url: String
}

struct DeleteRecordFileData: Codable {
    let message: String
    let status: Int
}
