//
//  ValidationUtility.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/5/24.
//

import Foundation

class ValidationUtility {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTest.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[.!@#$%]).{8,15}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    static func isValidNickname(_ nickname: String) -> Bool {
        let forbiddenStrings = ["fuck", "shit", "bitch", "ass"]
        let specialCharacterRegex = ".*[^A-Za-z0-9가-힣].*"
        
        return nickname.count >= 3 && nickname.count <= 15 &&
               !nickname.contains(" ") &&
               !forbiddenStrings.contains { nickname.lowercased().contains($0) } &&
               nickname.range(of: specialCharacterRegex, options: .regularExpression) == nil
    }

    static func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameRegex = "^[a-zA-Z가-힣]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        return !trimmedName.isEmpty &&
               name.count >= 2 &&
               name.count <= 20 &&
               nameTest.evaluate(with: trimmedName) &&
               !trimmedName.contains(" ")
    }

    static func isValidContact(_ contact: String) -> Bool {
        let contactRegex = "^010[0-9]{8}$"
        let contactTest = NSPredicate(format: "SELF MATCHES %@", contactRegex)
        return contactTest.evaluate(with: contact)
    }
}
