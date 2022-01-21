//
//  AddAlertViewController.swift
//  DrinkWater
//
//  Created by UAPMobile on 2022/01/21.
//

import UIKit

class AddAlertViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var pickedDate: ((_ date: Date) -> Void)?  // type을 closure로 선언
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // present 될 때 initialize(정의)된 closure를 실행한다.
        self.pickedDate?(self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
}
