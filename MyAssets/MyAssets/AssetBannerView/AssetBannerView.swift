//
//  AssetBannerView.swift
//  MyAssets
//
//  Created by 지정훈 on 2022/05/27.
//

import SwiftUI

struct AssetBannerView: View {
    
    let bannerlist: [AssetBanner] = [
        AssetBanner(title: "공지사항1", description: "추가된 공지사항 확인1", backgroundColor:.red),
        AssetBanner(title: "공지사항2", description: "추가된 공지사항 확인2", backgroundColor: .blue),
        AssetBanner(title: "공지사항3", description: "추가된 공지사항 확인3", backgroundColor: .yellow),
        AssetBanner(title: "공지사항4", description: "추가된 공지사항 확인4", backgroundColor: .green)
    ]
    @State private var currentPage = 0
    
    var body: some View {
        let bannerCards = bannerlist.map{BannerCard(banner: $0)}
        
        ZStack(alignment: .bottomTrailing){
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberOfPages: bannerlist.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count * 18))
                .padding(.trailing)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(contentMode: .fill)
    }
}

