//
//  Diary.swift
//  Diary
//
//  Created by 지정훈 on 2022/04/09.
//

import Foundation

//구조체
struct Diary {
    // 일기의 제목을 저장
    var title : String
    // 일기 내용 저장
    var contents: String
    // 일기 작성된 날짜 저장
    var date: Date
    // 일기 즐겨찾기 저장
    var isStar : Bool
}
