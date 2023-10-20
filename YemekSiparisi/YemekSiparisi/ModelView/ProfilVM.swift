//
//  ProfilVM.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 12.10.2023.
//


import Foundation
import FirebaseAuth

class ProfilVM {
    var settingsOptions: [String] = [
        "Profil Bilgileri",
        "Bildirim Ayarları",
        "Gizlilik ve Güvenlik",
        "Ödeme Yöntemleri",
        "Sipariş Geçmişi",
        "Adreslerim",
        "Dil ve Bölge",
        "Hesap Ayarları",
        "Yardım ve Destek",
        "Hakkında",
        "Şartlar ve Koşullar",
        "Gizlilik Politikası",
        "Sıkça Sorulan Sorular",
        "Uygulama Sürümü",
        "Bildirimleri Aç/Kapat",
        "Bildirim Tonu",
        "Dil Değiştir",
        "Şifre Değiştir",
        "Hesaptan Çıkış Yap",
        "Uygulamayı Kaldır"
    ]
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let err as NSError {
            completion(err)
        }
    }
    
    func getUsernameFromEmail() -> String? {
        if let email = Auth.auth().currentUser?.email {
            //mailin @ işaretinden öncesini almak için
            let components = email.components(separatedBy: "@")
            if components.count == 2 {
                var username = components[0]
                // İlk harfi büyük yapmak için
                username = username.prefix(1).capitalized + username.dropFirst()
                return username
            }
        }
        return nil
    }

}


