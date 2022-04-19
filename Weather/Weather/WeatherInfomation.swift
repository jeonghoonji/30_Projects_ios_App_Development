//
//  WeatherInfomation.swift
//  Weather
//
//  Created by 지정훈 on 2022/04/12.
//

import Foundation

//Codable 프로토콜 채택 자신을 변환하거나ㅌ 외부 표현으로 표현하는 타입을 말함 json을 말함

struct WeatherInfomation : Codable{
    // 밑에 선언된 구조체를 weather 배열로 선언
    let weather: [Weather]
    // json 메인키와 매핑 되어야됨
    // 밑에 있는 temp을 temp로 선언
    let temp: Temp
    //
    let name: String
    
    //CodingKey를 이용함
    // 위에 temp도 api키값이랑 단어가? 달라 
    enum CodingKeys: String,CodingKey{
        case weather
        case temp = "main"
        case name
    }
}

// 여기 부분은 api 키값이랑 이름이 같아서 enum사용후 CodingKey를 안해줘도됨
struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
// 여긴 api키 값이랑 이름이 달라서 한번더 설정

struct Temp: Codable{
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
        enum CodingKeys: String,CodingKey{
            case temp
            case feelsLike = "feels_like"
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
        }
}
