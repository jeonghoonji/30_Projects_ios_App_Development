//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by 지정훈 on 2022/04/21.
//

import Foundation
import UIKit
import Lottie

class CardDetailViewController: UIViewController{
    
    var promotionDetail: PromotionDetail?
    
    @IBOutlet weak var lottieView: AnimationView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    
    @IBOutlet weak var benefitDateLabel: UILabel!
    @IBOutlet weak var benefitDetailLabel: UILabel!
    @IBOutlet weak var benefiConditionLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = AnimationView(name:"money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let detail = promotionDetail else {return}
        
        titleLabel.text = """
        \(detail.companyName)카드쓰면
        \(detail.amount)만월 드려요
        """
        
        periodLabel.text = detail.period
        conditionLabel.text = detail.condition
        benefiConditionLabel.text = detail.benefitCondition
        benefitDateLabel.text = detail.benefitDate
        benefitDetailLabel.text = detail.benefitDetail
        
    }
    
}
