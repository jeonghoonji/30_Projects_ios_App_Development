//
//  AddAlertViewController.swift
//  Drink
//
//  Created by 지정훈 on 2022/07/09.
//

import Foundation
import UIKit
class AddAlertViewController: UIViewController{
    
    var pickedDate: ((_ date:Date)-> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
        
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func saveButtonButtonTapped(_ sender: Any) {
        pickedDate?(datePicker.date) 
        self.dismiss(animated: true,completion: nil)
    }
}
