//
//  CartVC.swift
//  YemekSiparisi
//
//  Created by Zehra Coşkun on 4.10.2023.
//


import UIKit
import RxSwift
import Kingfisher

class CartVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCartLabel: UILabel!
    
    var viewModel       = CartVM()
    var sepettekiListe  = [SepettekiYemekler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        
        _ = viewModel.sepettekiYemekListesi.subscribe(onNext: { liste in
            self.sepettekiListe = liste.sorted(by: { $0.yemek_adi! < $1.yemek_adi! })
            self.setBadge()
            self.tableView.reloadData()
        })
        tableView.reloadData()
        setTotalCartLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadCartView()
        NotificationCenter.default.addObserver(self, selector: #selector(itemDeleted(notification:)), name: Notification.Name("CartItemDeleted"), object: nil)
    }
    
    func uploadCartView(){
        viewModel.uploadCartList(kullanici_adi: "zehra")
        setBadge()
    }
    
    func setBadge(){
        viewModel.setBadge(sepettekiListe: sepettekiListe, tabBarItem: tabBarItem)
        setTotalCartPrice()
    }
    
    func setTotalCartLabel(){
        totalCartLabel.layer.cornerRadius = 8
        totalCartLabel.clipsToBounds = true
    }
    
    
    func setTotalCartPrice(){
        totalCartLabel.text = "₺ \(viewModel.setTotalCartPrice(sepettekiListe: sepettekiListe)),00"
    }
    
    
    @objc func itemDeleted(notification: Notification){
        uploadCartView()
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func confirmCart(_ sender: Any) {
        let alertController = UIAlertController(title: "Siparişiniz Hazırlanıyor",
                                                message: "Siparişiniz hazırlanıyor ve yakında yola çıkacak.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Kapat", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepettekiListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        let food            = sepettekiListe[indexPath.row]
        cell.foodName.text  = food.yemek_adi
        let imageURL        = viewModel.takePicOfFood(imageName: food.yemek_resim_adi!)
        if let url = imageURL{
            DispatchQueue.main.async {
                cell.foodImage.kf.setImage(with: url)
            }
        }
        cell.priceLabel.text    = "₺ \(food.yemek_fiyat!),00"
        cell.numberLabel.text   = " \(food.yemek_siparis_adet!) Adet"
        cell.deleteButton.tag   = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        cell.yemek = food
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = sepettekiListe[indexPath.row]
            sepettekiListe.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.deleteFromCart(sepet_yemek_id: Int(food.sepet_yemek_id!)!, kullanici_adi: "zehra")
            setBadge()
        }
    }
    
    @objc func deleteItem(sender: UIButton) {
        let indexP = IndexPath(row: sender.tag, section: 0)
        let yemek = sepettekiListe[indexP.row]
        if let intID = Int(yemek.sepet_yemek_id!) {
            viewModel.deleteFromCart(sepet_yemek_id: intID, kullanici_adi: "zehra")
            sepettekiListe.remove(at: indexP.row)
            tableView.deleteRows(at: [indexP], with: .fade)
            NotificationCenter.default.post(name: Notification.Name("CartItemDeleted"), object: nil)
        }
    }
    
    
    
    
    
}
