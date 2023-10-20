//
//  ListCell.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.
//

import UIKit
import Kingfisher

class ListCell: UITableViewCell {
    
    var viewModel = FoodListingVM()
    var yemek : Yemekler?

    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var funPic: UIImageView!
    
    @IBOutlet weak var addToCart: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        funPic.alpha = 0.5
        bgView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
