//
//  CreditCard.swift
//  CreditCardList
//
//  Created by 지정훈 on 2022/04/21.
//

import Foundation


struct CreditCard: Codable{
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool?
    
}

struct PromotionDetail:Codable{
    let companyName: String
    let period: String
    let amount: String
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
