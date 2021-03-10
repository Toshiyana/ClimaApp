//
//  WeatherData.swift
//  Clima
//
//  Created by Toshiyana on 2021/03/06.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

// jsonからswiftオブジェクトに変換するためのstruct
// Decodable protocolに従う必要あり(codable: DecodableとEncodableの両方を含むエイリアス)
// また，nameやtempなど変数名はjsonの変数名と，必ず同じ名前をつける
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather] //jsonがarrayであることに注意
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

