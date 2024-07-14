//
//  UserManager.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/14/24.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    var userModel: UserModel? {
        get {
            return loadUserFromUserDefaults()
        }
        set {
            saveUserToUserDefaults(newValue)
        }
    }
    
    private func loadUserFromUserDefaults() -> UserModel? {
        if let data = UserDefaults.standard.data(forKey: "userModel") {
            return try? JSONDecoder().decode(UserModel.self, from: data)
        }
        return nil
    }
    
    private func saveUserToUserDefaults(_ userModel: UserModel?) {
        if let userModel = userModel, let data = try? JSONEncoder().encode(userModel) {
            UserDefaults.standard.set(data, forKey: "userModel")
        } else {
            UserDefaults.standard.removeObject(forKey: "userModel")
        }
    }
    
    func deleteUserModel() {
        UserDefaults.standard.removeObject(forKey: "userModel")
    }
}
