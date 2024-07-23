//
//  YoutubeUtility.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/23/24.
//

import Foundation

class YoutubeUtility{
    
    static let shared = YoutubeUtility()
    
    private init() {}
    
    func getThumbnailUrl(_ url: String) -> String? {
        guard let urlComponents = URLComponents(string: url) else {
            print("url 파싱 실패")
            return nil
        }
        if let queryItems = urlComponents.queryItems {
            for item in queryItems {
                if item.name == "v", let videoID = item.value {
                    // 썸네일 URL을 생성합니다.
                    let thumbnailURL = "https://img.youtube.com/vi/\(videoID)/0.jpg"
                    return thumbnailURL
                }
            }
        }
        
        return nil
    }
    
    
    
}
