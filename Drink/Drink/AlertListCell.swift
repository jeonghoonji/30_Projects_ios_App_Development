//
//  AlertListCell.swift
//  Drink
//
//  Created by 지정훈 on 2022/07/09.
//

import UIKit
import UserNotifications

class AlertListCell: UITableViewCell {

    
    let userNotificaitonCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else {return}
//        alerts[sender.tag].isOn = sender.isOn
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        if sender.isOn{
            userNotificaitonCenter.addNotificationRequest(by: alerts[sender.tag])
        }else{
            userNotificaitonCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id] )

        }
    }
    
}
