//
//  WeatherManager.swift
//  Clima
//
//  Created by Toshiyana on 2021/03/02.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation //    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)の部分で必要


// swiftの慣習で関連するDelegateは同じファイルに書く
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)//WeatherManager内でのエラーが起きたときに利用するメソッド,エラーが発生する可能性がある箇所に記述
}

struct WeatherManager {
    // qの国をユーザが指定するパラメータは後から追加する（パラメータは順番に依存しないからok）ので，以下に書かない
    // httpsをhttpとすると，暗号化されてないために安全でないリクエストとみなされてエラーになるので注意（よくあるミスらしい）
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=bb091df4e5beb718f2d5e607adc535ca&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //print(urlString)
        performRequest(with: urlString)//同じ構造体・クラス内の関数を呼び出す場合selfをつけるが，推測できるので省略可能
    }
    
    // swiftはパラメータ名が異なれば，同じ名前の関数を定義可能!
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create a URL
        
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            // completionHandler,handleを理解しきれてないので，後で調べる!
            // completionHandlerの引数は関数（clousure）
            //let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)//インターネットに繋がらず，エラーになる可能性があるため記述
                    return//handleメソッドからexit
                }
                
                if let safeData = data {
                    //文字列でデータを試しで表示
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString!)
                    
                    //closures内で同じ構造体・クラス内の関数を呼び出す場合は，selfをつける（推測できないため）
                    //weatherは使うので，optional bindingでアンラップする
                    if let weather = self.parseJson(safeData) {
                        
                        //他のファイルのオブジェクトに縛られる書き方は良くない（天気の取得のための，WeatherMangerファイルを今後再利用できなくなってしまうから⇨delegate patternの利用）
                        //let weatherVC = WeatherViewController()
                        //print(weatherVC.didUpdateWeather(weather: weather))
                        
                        //closures内で同じ構造体・クラス内の関数を呼び出す場合は，selfをつける（推測できないため）
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }//クロージャーを使った書き方
            
            // 4. Start the task
            
            task.resume()// 再開と呼ぶ理由は，上のsession.dataTaskでタスクが生成された後，suspended stateになっているから
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {//実行可能な場合tryの内容を実行，エラーの場合catchの内容を実行
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            //print(decodedData.name)
            //print(decodedData.main.temp)
            //print(decodedData.weather[0].description)
            let weather = WeatherModel(conditionId: id, cityName: name, tempreture: temp)
            //print(weather.conditionName)
            //print(weather.tempretureString)
            return weather
        } catch {//decodeできずにエラーになった場合
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
        
    //    func handle(data: Data?, response: URLResponse?, error: Error?) {
    //        if error != nil {
    //            print(error!)
    //            return//handleメソッドからexit
    //        }
    //
    //        if let safeData = data {
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString!)
    //        }
    //    }
    
    
}

