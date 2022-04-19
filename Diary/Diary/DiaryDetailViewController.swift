//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 지정훈 on 2022/04/08.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject{
    //필요가 없어짐
    //func didSelectDelete(indexPath:IndexPath)
    //func didSelectStar(indexPath:IndexPath, isStar:Bool)
    
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    // 선언
    weak var delegate: DiaryDetailViewDelegate?
    // 일기장 리스트 화면에서 전달받을 프로퍼티 선언부
    var diary: Diary?
    var indexPath: IndexPath?
    
    //프로퍼티 만듬 즐겨차
    var starButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
    }
    
    
    // 프로퍼티에 통해 전달받은 다이어리 객체 뷰에 초기화
    private func configureView(){
        guard let diary = self.diary else {return}
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        //즐겨찾기 버튼 만들기
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        // 이부분은 동작 구현 부분이 아닌 뷰를 불러올때 나타내주는 isStar가 참이면 star.fill 거짓이면 star
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        // 별 색깔 오렌지색
        self.starButton?.tintColor = .orange
        // 네비게이션 아이템 오른쪽 바 버튼 아이템에 위에서 정의한 starButton을 넣어줌
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    //viewcontroller에 있으니 복사해옴
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    @objc func tapStarButton(){
        guard let isStar = self.diary?.isStar else {return}
        guard let indexpath = self.indexPath else {return}
        // 즐겨찾기 버튼을 눌렀을때
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        }else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        //이부분 잘 이해가 안감
        NotificationCenter.default.post(name: Notification.Name("starDiary"),
            object: [
                "isStar": self.diary?.isStar ?? false,
                "indexPath": indexpath
                ],
                userInfo: nil
        )
        //
        //self.delegate?.didSelectStar(indexPath: indexpath, isStar: self.diary?.isStar ?? false)
        
    }
    
    @objc func editDiaryNotification(_ notification: Notification){
        // 두줄 잘 모르겠음
        guard let diary = notification.object as? Diary else {return}
        guard let row = notification.userInfo?["indexPath.row"] as? Int else {return}
        //전달 받은 수정 된 객체를 전달
        self.diary = diary
        // 수정된 내용에 맞게 업데이트
        self.configureView()
    }
    

    @IBAction func tapEditButton(_ sender: UIButton) {
        // 수정버튼 눌렀을때 수정 화면으로 가게 해주는 부분
        guard let viewController = self.storyboard?.instantiateViewController(identifier:  "WriteDiaryViewController") as? WriteDiaryViewController else {return}
        //옵셔널 바인딩
        guard let indexPath = self.indexPath else {return}
        guard let diary = self.diary else {return}
        //위에 두문장이 키값 느낌     edit 을 전달하며 연관 값 전달 
        viewController.diaryEditorMode = .edit(indexPath, diary)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

    @IBAction func tapDeleteButton(_ sender: Any) {
        
        guard let indexPath = self.indexPath else {return}
        //self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    //인스턴스가 deinit될때 해당 인스턴스가 모두 제걷
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}


