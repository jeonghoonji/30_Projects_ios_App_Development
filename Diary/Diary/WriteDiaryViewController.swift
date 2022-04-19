//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 지정훈 on 2022/04/08.
//

import UIKit

//열거형 선언
enum DiaryEditorMode{
    case new
    case edit(IndexPath,Diary)
}
// 델리게이트 정의 델리케이트를 이용하여 다이어리 객체 전달
protocol WriteDiaryViewDelegate :AnyObject{
    // 이 메소드에 일기가 작성된 객체를 전달할 예정
    func didSelectReigster(diary: Diary)
}


class WriteDiaryViewController: UIViewController {
    
    // 제목 텍스트필드 변수
    @IBOutlet var titleTextField: UITextField!
    // 내용 텍스트 필드 변수
    @IBOutlet var contentsTextView: UITextView!
    // 날짜 텍스트 필드 변수
    @IBOutlet var dateTextField: UITextField!
    // 우측 상단 등록 버튼 변수
    @IBOutlet var confirmButton: UIBarButtonItem!
    // UiDatePicker 라는 인스턴스로 초기화
    private let datePicker = UIDatePicker()
    // 이 프로퍼티는 데이트피커에서 나온 데이트를 저장하는 프로퍼티
    private var diaryDate : Date?
    
    //정의
    weak var delegate : WriteDiaryViewDelegate?
    
    // 초기값은 new로 선언
    var diaryEditorMode : DiaryEditorMode = .new
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewDidLoad구문에서 함수를 불러와 실행
        self.configureContentsTextView()
        self.configureDatePicker()
        //등록 버튼 처음엔 비활설화 설정
        self.confirmButton.isEnabled = false
        self.configureInputField()
        self.configureEditorMode()
    }
    // 메소드 정의 상세화면 창에서 타이틍, 내용, 날짜값 전달 받는거 일듯
    private func configureEditorMode(){
        switch self.diaryEditorMode{
            case let .edit(_, diary):
                //diary값이라면 초기화
                self.titleTextField.text = diary.title
                self.contentsTextView.text = diary.contents
                self.dateTextField.text = self.dateToString(date: diary.date)
                self.diaryDate = diary.date
                self.confirmButton.title = "수정"
        default:
            break
        }
    }
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    // 우측 상단 등록 버튼 행동 변수
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else {return}
        guard let contents = self.contentsTextView.text else {return}
        guard let date = self.diaryDate else {return}
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        
        
        
        switch self.diaryEditorMode{
        case .new:
            self.delegate?.didSelectReigster(diary: diary)
        //이부분 빡셈
        case let .edit(indexPath, _):
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: [
                    "indexPath.row": indexPath.row
                ]
            )
            
        }
        //위에 switch문때문에 새로운 것은 case문으로 빠져 행동
        //self.delegate?.didSelectReigster(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }

    //
    private func configureContentsTextView(){
        // alpha 값은 투명도 0.0 ~ 1.0 값을 넣어줘야함
        let borderColor = UIColor ( red: 220/250, green: 220/250, blue: 220/250, alpha: 1.0 )
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        // 테두리 너비
        self.contentsTextView.layer.borderWidth = 0.5
        // 코너 둥굴 정도
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    //
    private func configureDatePicker(){
        //datepicker 모드 정하는거
        self.datePicker.datePickerMode = .date
        // 스타일
        self.datePicker.preferredDatePickerStyle = .wheels
        // uicontroller 객체가 응답하는 방식
        // valueChanged때문에 값이 변경될때 마다 datePickerValueDidChange호출을 하게 되고
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko_KR") //이거 안해도 한국말 나와서 주석처리함
        self.dateTextField.inputView = self.datePicker
    }

    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        // DateFormatter 사람이 읽을수 있는 형식으로 변환
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy 년 MM월 dd일(EEEEE)"
        //한국말로 나오게
        formmater.locale = Locale(identifier: "ko_KR")
        //
        //
        self.diaryDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
        //datePicker에서 값을 입력하는 것이 텍스트필드가 아닌 데이트피커이므로 아래에있는 구문을 통해 날짜가 변경될때 마다 editingChanged 발생하여 dateTextFieldDidChange이 호출되어 해결
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    private func configureInputField(){
        self.contentsTextView.delegate = self
        // 제목 테스트필드에 입력 될때마다 editingChanged 실행
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        // 날짜 테스트필드에 입력 될때마다 editingChanged 실행
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    // select함수? 만든것 제목이 입력될때마다 등록이 활성화 여부 판단
    @objc private func titleTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    @objc private func dateTextFieldDidChange(_ textField:UITextField){
        self.validateInputField()

    }
    
    //유저가 화면을 터치하면 호출되어 실행되는 메소드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func validateInputField(){
        // 일기작성 텍스트필드에서 모든 세가지 요소들이 작성이 되어야 등록 버튼이 활성화 되게
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) &&
        !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
    
    
}

extension WriteDiaryViewController: UITextViewDelegate {
    // 메소드 구현 테스트뷰 텍스트가 입력 될때마다 호출됨
    func textViewDidChange(_ textView: UITextView) {
        // 계속 호출하여 빈곳이 있는지 없는지 판단
        self.validateInputField ()
    }
}
