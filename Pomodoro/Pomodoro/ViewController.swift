//
//  ViewController.swift
//  Pomodoro
//
//  Created by 지정훈 on 2022/04/11.
//

import UIKit
import AudioToolbox


enum TimersStatus{
    case start
    case pause
    case end
    
}


class ViewController: UIViewController {

    @IBOutlet weak var progressLabel: UIProgressView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    //프로퍼티 추가 duration는 타이머에 저장된 시간을 60으로 초기화
    var duration = 60
    // 초기값이 end로 설정
    var timerStatus: TimersStatus = .end
    //프로퍼티 선언
    var timer : DispatchSourceTimer?
    // 현재 카운터 되고있는 시간을 초로 저장하는 프로퍼티
    var currentSeconds = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
        
    }
    // 메소드 정의
    func setTimerInfoViewVisble(isHidden: Bool){
        //isHidden - true 숨김상태 / isHidden - false 나타나는 상대
        //그래서 함수 호출 넘어오는 값 false으로 넘겨 timerLabel,progressLabel을 나타나게 표시
        self.timerLabel.isHidden = isHidden
        self.progressLabel.isHidden = isHidden
    }
    // normal상태면 시작으로 변경  / selected면 일시정지로 변경
    func configureToggleButton(){
        //
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    func startTimer(){
        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            //.now는 타이머가 실행되면 즉시 실행되게끔   / repeating 1초마다 반복
            self.timer?.schedule(deadline: .now(), repeating: 1)
            //클로저 함수. 카운터 다운
            self.timer?.setEventHandler(handler: { [weak self] in
                // self가 strong으로 만듬   -> self?. 물음표 제거함
                guard let self = self else {return}
                self.currentSeconds -= 1
                
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600 ) / 60
                let seconds = (self.currentSeconds % 3600 ) % 60
                //
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour,minutes,seconds)
                //
                self.progressLabel.progress = Float(self.currentSeconds) / Float(self.duration)
                //debugPrint(self?.currentSeconds)
                // 클로저 구현?
                //rotationAngle이해안감
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi*2)
                })
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
            })
            // 타이머가 시작되게 구현
            self.timer?.resume()
        }
    }
    func stopTimer(){
        // 타이머 도중에 일시정지후 취소를 누르면 나타나는 오류를 해결하기 위한 코드
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        // 타이머가 종료되게 해줌
        self.timer?.cancel()
        //메모리에서 해제 !!!꼭 해줘야함 백그라운드에서 타이막 동작 될수있음
        self.timer = nil
        // timerStatus end로 변경
        self.timerStatus = .end
        // 취소버튼 비활성화으로 변경
        self.cancelButton.isEnabled = false
        // 타임라벨,게이지바 숨김 표현
        //self.setTimerInfoViewVisble(isHidden: true)
        // fasle값을 줌으로써 데이트타임피커 표시
        //self.datePicker.isHidden = false
        UIView.animate(withDuration: 0.5,animations: {
            // 투명도 값을 설정하여 표시해줌 
            self.timerLabel.alpha = 0
            self.progressLabel.alpha = 0
            self.datePicker.alpha = 1
            // 원래 이미지로 변경
            self.imageView.transform = .identity
        })
        //시작 으로 변환
        self.toggleButton.isSelected = false
    }
    

    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus{
        case .start, .pause:
            
            self.stopTimer()
        default:
            break
        }
        
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus{
        case .end:
            // datepicker에서 설정한 duration을 저장
            self.currentSeconds = self.duration
            //status를 시작 상태로 바꾸고
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5,animations: {
                self.timerLabel.alpha = 1
                self.progressLabel.alpha = 1
                self.datePicker.alpha = 0
            })
            //setTimerInfoViewVisble함수에 false값 전달
            //self.setTimerInfoViewVisble(isHidden: false)
            // true값을 줌으로써 datePickert를 숨김
            //self.datePicker.isHidden = true
            // 일시중지로 변환
            self.toggleButton.isSelected = true
            // 시작버튼을 처음 눌러 처음에 취소버튼 enabled값을 true로 변경하여 활성화
            self.cancelButton.isEnabled = true
            //
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            //시작으로 변환
            self.toggleButton.isSelected = false
            //타이머를 일시정지 시킴
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            
            //일시중지로 변환
            self.toggleButton.isSelected = true
            //타이머 다시 시작
            self.timer?.resume()

        }
    }
}

