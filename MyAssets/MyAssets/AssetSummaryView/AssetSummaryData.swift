//
//  AssetSummaryData.swift
//  MyAssets
//
//  Created by 지정훈 on 2022/05/27.
//

import SwiftUI

class AssetSummaryData: ObservableObject {
    @Published var assets: [Asset] = load("assets.json")
    
   //swiftui 프로퍼티 래퍼 공부
    
}

func load <T:Decodable>(_ filename: String)-> T{
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError(filename + "을 찾을수 없습니다")
    }
    do{
        data = try Data(contentsOf: file)
    }catch{
        fatalError(filename+"을 찾을수 없습니다")
    }
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch{
        fatalError(filename+"을 \(T.self)로 파싱할수 없습니다")
    }
}
