//
//  EmailFinderManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/28/24.
//

import Foundation
import Alamofire

struct EmailFinderParameter: Encodable {
    let phoneNumber: String
    let name: String
}

struct EmailFinderManager {
    
    private let url = "https://voqal.codns.com/find/email"
    
    func findEmail(_ contact: String, _ name: String, completion: @escaping (EmailFinderModel?) -> Void) {
        
        let parameter = EmailFinderParameter(phoneNumber: contact, name: name)
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseDecodable(of: EmailFinderModel.self) { (response) in
            switch response.result {
            case .success(let data):
                print("결과: \(data)")
                completion(data)
                
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
        
//        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).response { response in
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("입력 값 contact: \(parameter.phoneNumber), name: \(parameter.name)")
//                print("Response data: \(utf8Text)")
//            }
//
//            switch response.result {
//            case .success(let data):
//                // Handle successful response
//                completion(emailFinderModel)
//            case .failure(let error):
//                // Handle failure
//                completion(nil)
//            }
//        }
    }
    
    
    
}
