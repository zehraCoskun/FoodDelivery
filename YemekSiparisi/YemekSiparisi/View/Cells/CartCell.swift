//
//  CartCell.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.
//


import UIKit
import RxSwift

class CartCell: UITableViewCell {
    
    var yemek = SepettekiYemekler()
    var viewModel = CartVM()
    
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
       
    @IBAction func deleteButton(_ sender: Any) {
        
    }
    
    
}


