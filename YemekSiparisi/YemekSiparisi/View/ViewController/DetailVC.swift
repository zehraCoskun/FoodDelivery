//
//  DetailVC.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    var viewModel = DetailVM()
    var yemek: Yemekler?
    var sepettekiListe = [SepettekiYemekler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.uploadCart(kullanici_adi: "zehra")
        _ = viewModel.sepettekiYemekListesi.subscribe(onNext: { liste in
            self.sepettekiListe = liste
        })
        
        if let y = yemek{
            foodName.text   = y.yemek_adi
            
            _ = viewModel.totalPrice.subscribe(onNext: { price in
                self.priceLabel.text = "₺ \(price),00"
            })
            _ = viewModel.orderQuantity.subscribe(onNext: { q in
                self.numberLabel.text = "\(q)"
            })
            priceLabel.text = "₺ \(y.yemek_fiyat!),00"
            
            let imageURL    = viewModel.takePicOfFood(imageName: (y.yemek_resim_adi!))
            if let url      = imageURL {
                DispatchQueue.main.async {
                    self.foodImage.kf.setImage(with: url)
                }
            }
        }
        
        rateView.layer.cornerRadius = 8
    }
    
    
    @IBAction func orderQuantityButton(_ sender: UIButton) {
        viewModel.quantityCal(sender: sender)
        viewModel.calculateTotalPrice(price: Int((yemek?.yemek_fiyat)!)!)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        viewModel.addAgainTocart(sepettekiListe: sepettekiListe, yemek: yemek, viewModel: viewModel)
        dismiss(animated: true)
        
    }
    
    
    
}

