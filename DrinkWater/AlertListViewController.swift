//
//  AlertListViewController.swift
//  DrinkWater
//
//  Created by UAPMobile on 2022/01/21.
//

import UIKit

class AlertListViewController: UITableViewController {
    var alerts: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlertListCell", bundle: .main)
        self.tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.alerts = self.alertList()
    }
    
    @IBAction func addAlertButtonAction(_ sender: Any) {
        guard let addAlertVC = self.storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        // closure 구현
        addAlertVC.pickedDate = {
            [weak self] date in
            guard let self = self else { return }
            var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true)
            alertList.append(newAlert)
            alertList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
            self.alerts = alertList
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
            
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
    }
    
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        return alerts
    }
}

extension AlertListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alerts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🚰물 마실 시간"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        cell.alertSwitch.isOn = self.alerts[indexPath.row].isOn
        cell.timeLabel.text = self.alerts[indexPath.row].time
        cell.meridiemLabel.text = self.alerts[indexPath.row].meridiem
        cell.alertSwitch.tag = indexPath.row  // AlertListCell 이 자신의 index를 알 수 있게 한다.
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            self.alerts.remove(at: indexPath.row)  // sorted 기준인 시간을 수정할 일은 없기 때문에 단순히 indexpath.row 로 특정하여 삭제해도 좋다
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
            return
        default:
            break
        }
    }
}
