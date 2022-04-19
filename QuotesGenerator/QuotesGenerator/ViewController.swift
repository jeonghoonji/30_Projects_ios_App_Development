//
//  ViewController.swift
//  QuotesGenerator
//
//  Created by 지정훈 on 2022/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var NameLabel: UILabel!      //파란색 박스 안에 들어가는 명언을 남긴 사람의 이름 라벨
    @IBOutlet weak var QuotesLabel: UILabel!    //파란색 박스 안에 들어가는 명언 글귀 라벨
    // 배열로 구조체를 이용하여 명언 모음집
    let qutoes = [
        Quote(contents:"죽임을 두려워하는 나머지 삶을 시작조차 못하는 사람이 많다" , name: "밴다이크"),
        Quote(contents:"나는 나 자신을 빼 놓고는 모두 안다" , name: "비용"),
        Quote(contents:"편견이란 실효성이 없는 의견이다" , name: "암브로스 빌"),
        Quote(contents:"분노는 바보들의 가슴속에서만 살아간다" , name: "아인슈타인"),
        Quote(contents:"몇번이라도 좋다! 이 끔찍한 생이여 다시!" , name: "니체")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // 명언 생성기 버튼 구현 버튼 => ar
    @IBAction func QuotesButton(_ sender: Any) {
        let random = Int(arc4random_uniform(5))
        let quote = qutoes[random]
        self.QuotesLabel.text = quote.contents
        self.NameLabel.text = quote.name
    }
}

