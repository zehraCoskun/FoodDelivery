//
//  InitialViewController.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 19.10.2023.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            // Kullanıcı oturum açmışsa, ana ekran veya ana görünüme yönlendirin.
            let foodListingVC = storyboard?.instantiateViewController(withIdentifier: "foodListingVC") as! FoodListingVC
            navigationController?.pushViewController(foodListingVC, animated: false)
        } else {
            // Kullanıcı oturum açmamışsa, giriş ekranına yönlendirin.
            let signInVC = storyboard?.instantiateViewController(withIdentifier: "signInVC") as! SignInVC
            navigationController?.pushViewController(signInVC, animated: false)
        }
    }
}

