//
//  CityCovidOverview.swift
//  COVID19
//
//  Created by 지정훈 on 2022/04/13.
//

import Foundation

// 
struct CityCovidOverview:Codable{
    let korea: CovidOverview
    let seoul: CovidOverview
    let busan: CovidOverview
    let daegu: CovidOverview
    let incheon: CovidOverview
    let gwangju: CovidOverview
    let daejeon: CovidOverview
    let ulsan: CovidOverview
    let sejong: CovidOverview
    let gyeonggi: CovidOverview
    let gangwon: CovidOverview
    let chungbuk: CovidOverview
    let chungnam: CovidOverview
    let jeonbuk: CovidOverview
    let jeonnam: CovidOverview
    let gyeongbuk: CovidOverview
    let gyeongnam: CovidOverview
    let jeju: CovidOverview
    
}

struct CovidOverview: Codable{
    //countryNm
    let countryName: String
    let newCase: String
    let totalCase: String
    let recovered : String
    let death: String
    let percentage: String
    let newCcase: String
    let newFcase: String
}
