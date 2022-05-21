//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 지정훈 on 2022/04/21.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController:UITableViewController{
    
    var ref: DatabaseReference! //파이어베이스 realtime database
    //
    var creditCardList: [CreditCard] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
    
        ref = Database.database().reference()
        
        ref.observe(.value){ snapshot in
            guard let value = snapshot.value as? [String:[String:Any]] else {return}
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String:CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted {$0.rank < $1.rank}
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error{
                print("ERROR JSON parsing \(error.localizedDescription)")
            }
            
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return creditCardList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell",for:indexPath) as?
                CardListCell else {return UITableViewCell()}
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //상세화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier:
            "CardDetailViewController") as? CardDetailViewController else {return}
        
        //여기까지
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        //옵셔널 1
        let cardID = creditCardList[indexPath.row].id
        
        //파이어베이스쪽에서 선택되면 true값이 뜨게끔
//        ref.child("Item\(cardID)/isSelected").setValue(true)
        //ref.queryOrderedByKey(b)
    }
}
