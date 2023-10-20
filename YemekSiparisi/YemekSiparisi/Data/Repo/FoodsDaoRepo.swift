//
//  FoodsDaoRepo.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.
//

import Foundation
import RxSwift
import Alamofire
import UIKit

class FoodsDaoRepo{
    
    var yemekListesi            = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepettekiYemekListesi   = BehaviorSubject<[SepettekiYemekler]>(value: [SepettekiYemekler]())
    var orderQuantity           = BehaviorSubject<Int>(value: 1)
    var totalPrice              = BehaviorSubject<Int>(value: 1) //tek bir ürün çeşidinin toplam fiyatı
    
    //MARK: anasayfa güncelleme
    func uploadFoodList(){
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response{ response in
            if let data = response.data{
                do{
                    let res = try JSONDecoder().decode(YemeklerResponse.self, from: data)
                    if let list = res.yemekler{
                        self.yemekListesi.onNext(list)
                    }
                }catch{
                    print("Ana sayfa yükleme hatası : \(error.localizedDescription)")
                }
            }
        }
    }
    //MARK: anasayfayı kategorilere ayırma
    func categorizedList(yemekIDsToFilter: [String]) {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(YemeklerResponse.self, from: data)
                    if let list = res.yemekler {
                        // Filtreleme işlemi
                        let filteredList = list.filter { yemek in
                            return yemekIDsToFilter.contains(yemek.yemek_id!)
                        }
                        self.yemekListesi.onNext(filteredList)
                    }
                } catch {
                    print("Filtrelenmeiş liste yükleme hatası: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: sepet sayfasını güncelleme
    func uploadCartList(kullanici_adi: String){ // cvm
        let params: Parameters = ["kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response{ response in
            if let data = response.data{
                do{
                    let res = try JSONDecoder().decode(SepettekiYemeklerResponse.self, from: data)
                    if let list = res.sepet_yemekler{
                        self.sepettekiYemekListesi.onNext(list)
                    }
                }catch{
                    print("Sepet yükleme hatası : \(error.localizedDescription)")
                }
            }
        }
    }
    //MARK: sepete yemek ekleme
    func addToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String  ){
        let params: Parameters = ["yemek_adi":yemek_adi, "yemek_resim_adi":yemek_resim_adi, "yemek_fiyat":yemek_fiyat,"yemek_siparis_adet":yemek_siparis_adet, "kullanici_adi":kullanici_adi ]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response{ reponse in
            if let data = reponse.data{
                do{
                    let res = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    if res.success == 1{
                        self.uploadCartList(kullanici_adi: kullanici_adi)//sepete yemek ekledikten sonra sepeti güncelleme
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    //MARK: sepetten yemek silme
    func deleteFromCart(sepet_yemek_id:Int, kullanici_adi:String){ // cvm
        let params: Parameters = ["sepet_yemek_id":sepet_yemek_id, "kullanici_adi":kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response{ response in
            if let data = response.data{
                do{
                    let res = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    if res.success == 1 {
                        self.uploadCartList(kullanici_adi: kullanici_adi)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    //MARK: resmin URL'sini alma
    func takePicOfFood(imageName: String) -> URL? {
        let urlString = "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    //MARK: detay sayfasında adet ayarlama
    func quantityCal(sender: UIButton){
        if let buttonIdentifier = sender.accessibilityIdentifier {
            if buttonIdentifier == "minusButton" {
                let currentCount = (try? orderQuantity.value()) ?? 1
                let newCount = max(currentCount - 1, 1)
                orderQuantity.onNext(newCount)
                
            } else if buttonIdentifier == "plusButton" {
                let newCount = (try? orderQuantity.value()) ?? 1
                orderQuantity.onNext(newCount + 1)
            }
        }
    }
    //MARK:  adet değiştikten sonra ürün miktarını hesaplama
    func calculateTotalPrice(price: Int){
        let currentCount = (try? orderQuantity.value()) ?? 1
        let newPrice = currentCount * price
        totalPrice.onNext(newPrice)
    }
    
}
