//
//  WeatherModel.swift
//  Clima
//
//  Created by Toshiyana on 2021/03/06.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    // 講座では初期化していなかったが，必要ないのか？（安全性を考慮して，あった方が良い気がする）
    // stored property: 値を保持するプロパティ
    let conditionId: Int
    let cityName: String
    let tempreture: Double
    
    
    // computed property: 値を保持せずに計算するプロパティ
    var tempretureString: String {// Viewに表示するには，Stringにする必要あり
        return String(format: "%.1f", tempreture)
    }
    
    var conditionName: String {
        switch conditionId {// conditionId: 上記のstored property
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
    
//    // メソッドを用いず，var conditionNameのコンピューテッドプロパティを用いた方が良い(Modelでメソッドを定義するのはよくない)
//    func getConditionName(weatherId: Int) -> String {
//        // reference https://openweathermap.org/weather-conditions
//        switch weatherId {
//        case 200...232:
//            return "cloud.bolt"
//        case 300...321:
//            return "cloud.drizzle"
//        case 500...531:
//            return "cloud.rain"
//        case 600...622:
//            return "cloud.snow"
//        case 701...781:
//            return "cloud.fog"
//        case 800:
//            return "sun.max"
//        default:
//            return "cloud"
//        }
//    }
}
