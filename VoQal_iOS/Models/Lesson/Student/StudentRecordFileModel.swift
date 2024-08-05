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
    
    func loadDurations(completion: @escaping () -> Void) async {
        guard let currentData = data else { return }
        
        var durations = [(Int, TimeInterval)]()
        let queue = DispatchQueue(label: "duration.queue", attributes: .concurrent)
        let group = DispatchGroup()
        
        for (index, record) in currentData.enumerated() {
            if let s3Url = URL(string: "\(PrivateUrl.shared.getS3UrlHead())\(record.s3Url)"), record.s3Url.hasSuffix(".mp3") {
                group.enter()
                Task {
                    if let duration = try? await StudentRecordFileManager().getAudioDuration(from: s3Url) {
                        queue.async(flags: .barrier) {
                            durations.append((index, duration))
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            for (index, duration) in durations {
                self.data?[index].duration = duration
            }
            completion()
        }
    }
}
