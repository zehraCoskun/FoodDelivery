//
//  SignUpVC.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 17.10.2023.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    let viewModel = SignUpVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        backView.layer.cornerRadius = 24
        backView.clipsToBounds = true
        passwordTF.isSecureTextEntry = true
        hideKeyboardWhenTappedAround()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        viewModel.signUp(email: mailTF.text!, password: passwordTF.text!) { [weak self] error in
            if let error = error {
                self?.showError(error)
            } else {
                self?.performSegue(withIdentifier: "fromUpToHome", sender: nil)
            }
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
}




