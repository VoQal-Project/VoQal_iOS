//
//  CacheManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 10/25/24.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let lastReadTimeKey = "lastReadTime"
    
    func saveLastReadTime(_ timestamp: Int) {
        UserDefaults.standard.set(timestamp, forKey: lastReadTimeKey)
    }
    
    func getLastReadTime() -> Int? {
        return UserDefaults.standard.integer(forKey: lastReadTimeKey)
    }
}
