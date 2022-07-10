//
//  UNNotificationCenter.swift
//  Drink
//
//  Created by 지정훈 on 2022/07/11.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter{
    func addNotificationRequest(by alert: Alert){
        let content = UNMutableNotificationContent()
        content.title = " 물 마실 시간입니다"
        content.body = " 세계 보건 기구 who가 권장하는 하루 물 섭취량은 1.5~2리터 입니다"
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute ], from: alert.date )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
        
        
    }
}
