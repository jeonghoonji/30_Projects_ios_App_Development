//
//  RoundButton.swift
//  Calculater
//
//  Created by 지정훈 on 2022/03/28.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet{
            if isRound{
                self.layer.cornerRadius = self.frame.height/2
            }
        }
    }

}
