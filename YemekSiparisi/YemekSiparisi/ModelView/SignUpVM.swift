//
//  SignUpVM.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 18.10.2023.
//

import Foundation
import FirebaseAuth

class SignUpVM {
    func signUp(email: String, password: String, completion: @escaping (String?) -> Void) {
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" || 
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            completion("Fill in the empty fields in the list")
        } else if password.count < 5 {
            completion("Your password must be at least 5 characters")
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(error.localizedDescription)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
