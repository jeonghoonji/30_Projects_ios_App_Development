//
//  NavigationBarWithButton.swift
//  MyAssets
//
//  Created by 지정훈 on 2022/05/27.
//

import SwiftUI

//ViewModifier 수정자를 만듬 - 뷰의 버튼을 함수처럼 적용함으로써 바로 적용 가능
struct NavigationBarWithButton: ViewModifier {
    
    var title:String = ""
    
    func body(content: Content) -> some View {
        return content
            .navigationBarItems(
                //leading-글자가 시작되는 방향 내 자산 라벨 표시
                leading: Text(title).font(.system(size: 24, weight: .bold)).padding(),
                //trailing - 글자가 끝나는 방향 버튼 추가
                trailing: Button(action: { print("자산추가버튼 tapped") },
                //버튼에 대한 자세한 설정
                label: {
                    Image(systemName: "plus")
                    Text("자산추가").font(.system(size: 21))
                    }
                )
            //버튼에 대한 추가 설정
            //자산추가 버튼 색깔, 패딩, 버튼코너
            .accentColor(.black)
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black))
         )
        //네비게이션 바 아이템의 세부 설정
         .navigationBarTitleDisplayMode(.inline)
        //네비게이션바가 자연스럽게 표현 퍼포먼스 추가
         .onAppear{
             let appearance = UINavigationBarAppearance()
             // 투명한 백그라운드
             appearance.configureWithTransparentBackground()
             // 투명하지만 컬러값 조정
             appearance.backgroundColor = UIColor(white: 1, alpha: 0.5)
             UINavigationBar.appearance().standardAppearance = appearance
             UINavigationBar.appearance().compactAppearance = appearance
             UINavigationBar.appearance().scrollEdgeAppearance = appearance
         }
    }
}
extension View{
    func navigationBarWithButtonStyle(_ title:String) -> some View {
        return self.modifier(NavigationBarWithButton(title: title))
    }
}

struct NavigationBarWithButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Color.gray.edgesIgnoringSafeArea(.all)
                .navigationBarWithButtonStyle("내 자산")
        }
    }
}
