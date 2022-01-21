//
//  Alert.swift
//  DrinkWater
//
//  Created by UAPMobile on 2022/01/21.
//

import Foundation

struct Alert: Codable{
    var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    var meridiem: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "a"
        return timeFormatter.string(from: date)
    }
}
