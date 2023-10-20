//
//  ProfilVC.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.
//

import UIKit
import FirebaseAuth

class ProfilVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    let viewModel = ProfilVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        imagePick()
        
        if let username = viewModel.getUsernameFromEmail() {
            nameLabel.text = "Merhaba " + username
        }
    }
    
    func imagePick() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilImage.addGestureRecognizer(tapGesture)
        profilImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped() {
        showImagePicker()
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Hata!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showSignOutConfirmationAlert() {
        let alert = UIAlertController(title: "Çıkış Yap", message: "Çıkış yapmak üzeresiniz. Emin misiniz?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "İptal", style: .default, handler: nil)
        let signOutAction = UIAlertAction(title: "Çıkış Yap", style: .destructive) { _ in self.viewModel.signOut { [weak self] error in
            if let error = error {
                self?.showErrorAlert(message: "Hesaptan çıkış yaparken hata oluştu: \(error.localizedDescription)")
            } else {
                self?.performSegue(withIdentifier: "toSignUpAgain", sender: nil)
            }
        }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(signOutAction)
        
        present(alert, animated: true, completion: nil)
    }
  
}

extension ProfilVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profilImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfilVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilCell", for: indexPath) as! ProfilCell
        cell.cellLabel.text = viewModel.settingsOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 18 {
            showSignOutConfirmationAlert()
        }
    }
}



