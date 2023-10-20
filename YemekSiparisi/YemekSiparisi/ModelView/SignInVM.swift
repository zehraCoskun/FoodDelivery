//
//  SignInVM.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 18.10.2023.
//

import Foundation
import FirebaseAuth

class SignInVM {
    func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
}
