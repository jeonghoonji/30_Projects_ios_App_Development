//
//  SettingViewController.swift
//  LEDBoardApp
//
//  Created by 지정훈 on 2022/03/25.
//

import UIKit

//프로토콜 정의
protocol LEDBoardSettingDelegate : AnyObject{
    //프로토콜에서 함수만듬
    func changeSetting(text: String? , textColor: UIColor , backgroundColor: UIColor)
}

class SettingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    // 글자 색깔 바꾸는 버튼
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    // 배경화면 바꾸는 버튼
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    //?????
    weak var delegate : LEDBoardSettingDelegate?
    //????
    var ledText: String?
    
    //초기화??
    var textColor : UIColor = .yellow
    var backgroundColor : UIColor = .black

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    private func configureView(){
        if let ledText = self.ledText{
            self.textField.text = ledText
        }
        self.changeTextColorButton(color: self.textColor)
        self.changeBackgroundColorButton(color: self.backgroundColor )
    }
    
    @IBAction func tapTextColorButton(_ sender: UIButton) {
        if sender == self.yellowButton{
            self.changeTextColorButton(color: .yellow)
            self.textColor = .yellow
        }else if sender == self.purpleButton{
            self.changeTextColorButton(color: .purple)
            self.textColor = .purple
        }else {
            self.changeTextColorButton(color: .green)
            self.textColor = .green
        }
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton{
            self.changeBackgroundColorButton(color: .black)
            self.backgroundColor = .black
        }else if sender == self.blueButton{
            self.changeBackgroundColorButton(color: .blue)
            self.backgroundColor = .blue
        }else {
            self.changeBackgroundColorButton(color: .orange)
            self.backgroundColor = .orange
        }
    }
    @IBAction func tapSaveButton(_ sender: UIButton) {
        self.delegate?.changeSetting(
            text: textField.text,
            textColor: self.textColor,
            backgroundColor: self.backgroundColor
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //
    private func changeTextColorButton(color: UIColor){
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
    }
    private func changeBackgroundColorButton(color: UIColor){
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
        
    }
   
}
