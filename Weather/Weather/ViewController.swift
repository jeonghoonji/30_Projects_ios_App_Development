//
//  ViewController.swift
//  Weather
//
//  Created by 지정훈 on 2022/04/12.
//

import UIKit

class ViewController: UIViewController {

    //텍스트 필드
    @IBOutlet weak var cityNameTextField: UITextField!
    // 날씨 지역 라벨
    @IBOutlet weak var cityNameLabel: UILabel!
    // 날씨 예) 맑은, 흐름, 등등 라벨
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    //굵은 온도 라벨
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var weatherStackView: UIStackView!
    // 최고 온도 라벨
    @IBOutlet weak var maxTempLabel: UILabel!
    // 최저 온도 라벨
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    // 날씨 가져오기 버튼 액션 / self.cityNameTextField.text에서 cityName 으로 검색할 지역이름 가져오기
    //getCurrentWeather함수 호출 cityname 넘겨 api호출하는데 도움
    //
    @IBAction func tapFetchWeatherButton(_ sender: Any) {
        if let cityName = self.cityNameTextField.text{
            self.getCurrentWeather(cityName: cityName)
            //버튼이 눌리면 키보드 사라지게
            self.view.endEditing(true)
        }
    }
    
    func getCurrentWeather(cityName: String){
        // api를 호출하는 구문 중간에 cityName 변수를 넣고 함수호출시 cityName을 할당받아 get할수있음
        // 상수 선언
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=c91ee37768240e61b5dc6ade9dfa4da1") else {return}
        // configuration 결정후 행동함?
        // 기본 세선이 되게 설정
        let session = URLSession(configuration: .default)
        // 서버로 데이터를 요청  url / 컴플리션 핸들러 클로저 정의? data- 서버에서 응답받은 데이터  response - http헤더 및 상태코드 응답 메타데이타? error- 실패시 error객체 성공시 nil
        session.dataTask(with: url){[weak self] data, response , error in
            // 통과되는 범위 설정
            let successRange = (200..<300)
            //디코딩?
            //옵셔널 바인딩
            guard let data = data, error == nil else {return}
            // 디코더 상수 선언   JSONDecoder-json객체에서 데이터유형의 인스턴스 ..??
            let decoder = JSONDecoder()
            // 다운 캐스팅 
            if let response = response as? HTTPURLResponse , successRange.contains(response.statusCode){
                // 서버에서 응답받은 json객체를 WeatherInfomation으로 변환할수있음
                guard let weatherInformation = try? decoder.decode(WeatherInfomation.self, from: data) else {return}
                //debugPrint(weatherInformation)
                // 메인 스레드
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            }else{
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else {return}
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        //
        }.resume()
    }
    
    //
    func configureView(weatherInformation: WeatherInfomation){
        // api에서 가져온 지역 이름을 cityNameLabel에 넣는거 같음
        self.cityNameLabel.text = weatherInformation.name
        // 첫번째를 인자를 넣는다
        if let weather = weatherInformation.weather.first{
            self.weatherDescriptionLabel.text = weather.description
        }
        // weatherInformation.temp.temp은 온도 표시법이 달라 -273.15 뺌
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))도"
        self.minTempLabel.text = " 최저: \(Int(weatherInformation.temp.minTemp - 273.15))도"
        self.maxTempLabel.text = "최고:\(Int(weatherInformation.temp.maxTemp - 273.15))도"
    }
    
    // 에러가 나타났을때 실행해주는 함수
    func showAlert(message:String){
        //  alert의 본문 내용 message는 어떤 오류가 났는지 표시
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        //오류가 났을때 액션인거같음 확인버튼도 생김
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        //???
        self.present(alert, animated: true, completion: nil)
    }
}

