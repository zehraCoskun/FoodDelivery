//
//  FoodListingVC.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.


import UIKit
import RxSwift

class FoodListingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    var viewModel       = FoodListingVM()
    var yemekListesi    = [Yemekler]()
    var sepettekiListe  = [SepettekiYemekler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        _ = viewModel.yemekListesi.subscribe(onNext: { list in
            self.yemekListesi = list
            self.tableView.reloadData()
        })
        
        viewModel.uploadCart(kullanici_adi: "zehra")
        _ = viewModel.sepettekiYemekListesi.subscribe(onNext: { liste in
            self.sepettekiListe = liste
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.uploadFoodList()
        categoryControl.selectedSegmentIndex = 0 //sayfa her açıldığında tüm kategoriler seçili
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //tıklanan hücredeki yemeği detay sayfasına gönderme
        if segue.identifier == "toDetail"{
            if let yemek = sender as? Yemekler{
                let toVC = segue.destination as! DetailVC
                toVC.yemek = yemek
            }
        }
    }
    
    @IBAction func categoryControl(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex{
        case 0: viewModel.uploadFoodList()
        case 1: viewModel.categorizedList(idList: viewModel.mainIDsToFilter)
        case 2: viewModel.categorizedList(idList: viewModel.desertIDsToFilter)
        case 3: viewModel.categorizedList(idList: viewModel.drinkIDsToFilter)
        default:
            break
        }
    }
}

extension FoodListingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemekListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        let food            = yemekListesi[indexPath.row]
        cell.foodName.text  = food.yemek_adi
        cell.price.text     = "₺ \(food.yemek_fiyat!),00"
        let imageURL        = viewModel.takePicOfFood(imageName: food.yemek_resim_adi!)
        if let url = imageURL {
            DispatchQueue.main.async {
                cell.foodImage.kf.setImage(with: url)
            }
        }
        
        //arka plandaki resimleri ayarlanması
        if viewModel.drinkIDsToFilter.contains(food.yemek_id!){
            cell.funPic.image = UIImage(named: "drink")
        } else if viewModel.desertIDsToFilter.contains(food.yemek_id!){
            cell.funPic.image = UIImage(named: "dessert")
        } else{
            cell.funPic.image = UIImage(named: "steak")
        }
        
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(addToCartFunc), for: .touchUpInside)
        
        cell.yemek = food
        cell.selectionStyle = .none //hücre seçimini kapatma
        return cell
    }
    
    @objc func addToCartFunc(sender: UIButton){ //hücre içindeki sepete ekleme butonunun ayarları
        sender.isEnabled = false
        let indexP = IndexPath(row: sender.tag, section: 0)
        let yemek = yemekListesi[indexP.row]
        viewModel.addAgainTocart(sepettekiListe: sepettekiListe, yemek: yemek, viewModel: viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { //butonun tekrar aktif olmasını bekletme
            sender.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //sola kaydırarak silme
        let yemek = yemekListesi[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: yemek)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

