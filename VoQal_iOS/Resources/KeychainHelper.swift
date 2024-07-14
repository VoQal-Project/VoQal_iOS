//
//  KeychainHelper.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import KeychainAccess

class KeychainHelper{
    
    static let shared = KeychainHelper()
    private let keychain = Keychain(service: "com.yourapp.service")
    
    private init() {}
    
    func saveAccessToken(_ token: String) {
        keychain["accessToken"] = token
    }
    
    func getAccessToken() -> String? {
        return keychain["accessToken"]
    }
    
    func saveRefreshToken(_ token: String) {
        keychain["refreshToken"] = token
    }
    
    func getRefreshToken() -> String? {
        return keychain["refreshToken"]
    }
    
    func clearTokens() {
        try? keychain.remove("accessToken")
        try? keychain.remove("refreshToken")
    }
    
}
