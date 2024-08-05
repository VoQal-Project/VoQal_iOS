//
//  StudentRecordFileModel.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import Foundation

class StudentRecordFileModel {
    
    init(status: Int, data: [StudentRecordFile]? = nil) {
        self.status = status
        self.data = data
    }
    
    let status: Int
    var data: [StudentRecordFile]?
    
    var sortedData: [StudentRecordFile]? {
        data?.sorted(by: { firstRecordFile, secondRecordFile in
            let firstDate = DateUtility.convertStringToDate(firstRecordFile.recordDate)
            let secondDate = DateUtility.convertStringToDate(secondRecordFile.recordDate)
            
            return firstDate > secondDate
        })
    }
    
    func loadDurations() async {
            guard var data = data else { return }
            
            await withTaskGroup(of: Void.self) { group in
                for i in 0..<data.count {
                    if let s3Url = URL(string: data[i].s3Url), data[i].s3Url.hasSuffix(".mp3") {
                        group.addTask {
                            if let duration = try? await StudentRecordFileManager().getAudioDuration(from: s3Url) {
                                DispatchQueue.main.async {
                                    data[i].duration = duration
                                }
                            }
                        }
                    }
                }
            }
            
            self.data = data
        }
}
