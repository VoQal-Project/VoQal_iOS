//
//  HomeManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/13/24.
//

import Foundation
import Alamofire

struct HomeManager {
    private let url = "https://www.voqal.today/user/details"
    
    func getUserInform(completion: @escaping (HomeModel?) -> Void) {
        AF.request(url, method: .get, interceptor: AuthInterceptor()).responseDecodable(of: HomeData.self) { response in
            switch response.result {
            case .success(let res):
                if (200...299).contains(res.status) {
                    print("getUserInform: \(res)\nAccess Token: \(KeychainHelper.shared.getAccessToken())\nRefresh Token: \(KeychainHelper.shared.getRefreshToken())")
                    guard let data = res.data else { print("getUserInform data 프로퍼티 에러"); return }
                    let successModel = HomeSuccessModel(nickname: data.nickName,
                                                        email: data.email,
                                                        name: data.name,
                                                        phoneNum: data.phoneNum,
                                                        role: data.role,
                                                        status: res.status,
                                                        lessonSongUrl: data.lessonSongUrl,
                                                        assignedCoach: data.assignedCoach
                    )
                    let model = HomeModel(successModel: successModel, errorModel: nil)
                    completion(model)
                } else {
                    let errorModel = HomeErrorModel(status: res.status,
                                                    message: res.message,
                                                    error: res.error,
                                                    code: res.code)
                    let model = HomeModel(successModel: nil, errorModel: errorModel)
                    completion(model)
                }
            case .failure(let err):
                print("유저 디테일 받아오기 실패: \(err)")
                completion(nil)
            }
        }
    }
    
    func getLessonSongThumbnail(_ url: String, completion: @escaping (HomeThumbnailModel?) -> Void) {
        // 유튜브 ID 추출
        if let youtubeID = extractYouTubeID(from: url) {
            // 썸네일 URL 생성
            if let thumbnailURL = youtubeThumbnailURL(from: youtubeID) {
                // 이미지 다운로드
                AF.download(thumbnailURL).responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            let model = HomeThumbnailModel(thumbnail: image)
                            completion(model)
                        } else {
                            completion(nil)
                        }
                    case .failure(let error):
                        print("Error downloading image: \(error)")
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    func extractYouTubeID(from url: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: url.count)
        let matches = regex?.matches(in: url, options: [], range: range)
        if let match = matches?.first, let range = Range(match.range, in: url) {
            return String(url[range])
        }
        return nil
    }
    
    func youtubeThumbnailURL(from youtubeID: String) -> URL? {
        return URL(string: "https://img.youtube.com/vi/\(youtubeID)/hqdefault.jpg")
    }
    
}
