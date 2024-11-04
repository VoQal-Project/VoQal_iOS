//
//  RecordFileListModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import Foundation

struct RecordFileListModel {
    let status: Int
    let data: [RecordFile]?
}

struct DeleteRecordFileModel {
    let message: String
    let status: Int
}
