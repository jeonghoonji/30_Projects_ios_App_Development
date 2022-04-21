//
//  CardListCell.swift
//  CreditCardList
//
//  Created by 지정훈 on 2022/04/21.
//

import UIKit

class CardListCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
