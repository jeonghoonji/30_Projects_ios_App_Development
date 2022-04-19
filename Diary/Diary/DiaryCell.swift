//
//  DiaryCell.swift
//  Diary
//
//  Created by 지정훈 on 2022/04/08.
//

import UIKit
//컨텐트 뷰 안에 셀 스위프트 파일
class DiaryCell: UICollectionViewCell {
    // 셀 안에 있는 제목 라벨
    @IBOutlet var titleLabel: UILabel!
    // 셀 안에 있는 날짜 라벨
    @IBOutlet var dateLabel: UILabel!
    
    
    // 생정자 정의 ????????????이건 다시봐야함
    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor =  UIColor.black.cgColor
    }
}
