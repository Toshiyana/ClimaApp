////  参考：https://www.appsdeveloperblog.com/determine-users-current-location-example-in-swift/, https://www.zerotoappstore.com/how-to-get-current-location-in-swift.html
//
//// requestLocation()で一度だけ位置情報を取得せずに，locationManager.startUpdatingLocation()で位置情報を常に取得し追跡可能なバージョン（自分で試したモノ）
//
//import UIKit
//import CoreLocation
//
//class WeatherViewController: UIViewController {
//    
//    @IBOutlet weak var conditionImageView: UIImageView!
//    @IBOutlet weak var temperatureLabel: UILabel!
//    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var searchTextField: UITextField!
//    
//    var weatherManager = WeatherManager()//letじゃダメなのか
//    let locationManager = CLLocationManager()//GPSにより現在位置の取得が可能なオブジェクト
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        locationManager.requestWhenInUseAuthorization()//アプリ起動時に，現在位置をGPSで取得するかどうかPopUpでユーザに確認する
//        locationManager.requestAlwaysAuthorization()//バックグラウンドで常にGPSを起動して良いか確認（info.plistにこれのpopupに関する記述を追加する必要あり）
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters//GPSの取得精度を指定（10m)
//            locationManager.startUpdatingLocation()
//        }
//        
//        searchTextField.delegate = self
//        weatherManager.delegate = self
//    }
//}
//
//// extensionを利用してコードを読みやすくする
//// 各protocolに関連する処理を記述
////MARK: - UITextFieldDelegate
//extension WeatherViewController: UITextFieldDelegate {
//    
//    @IBAction func searchPressed(_ sender: UIButton) {
//        searchTextField.endEditing(true)
//        //print(searchTextField.text!)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        //print(searchTextField.text!)
//        return true
//    }
//    
//    // textFieldの編集を終了するかどうか許可を出すメソッド（validationをかけられる）
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        // searchTextFieldでなく，textFieldにすることですべての自作（IBOutlet）のTextFieldに適用されるメソッドとなる．（これは，buttonのsenderも同様）
//        if textField.text != "" {
//            return true // キーボードを閉じる
//        } else {
//            textField.placeholder = "Type something"
//            return false // キーボードを開いたまま
//        }
//    }
//    
//    // textFieldを入力してgoボタンを押した後，textField内の文字を除去
//    // searchTextField.endEditing(true)が実行された後に行われる
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        // Use searchTextField.text to get the weather for that city.
//        // searchTextField.textはオプショナル型なので，値が入っていれば定数cityに代入して，中身を実行．そうでなければ，スキップ．
//        if let city = searchTextField.text {
//            weatherManager.fetchWeather(cityName: city)
//        }
//        
//        searchTextField.text = ""
//    }
//}
//
////MARK: - WeatherManagerDelegate
//extension WeatherViewController: WeatherManagerDelegate {
//    // delegate methodはappleの慣習で外部パラメータ名は_で省略するので，自作delegate methodでも同様に省略する（appleと同様に，どのオブジェクトが関連しているかわかるように，weatherManagerも引数に書く）
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
//        //temperatureLabel.text = weather.tempretureString//weatherManagerのtask = session.dataTask(with: url)のネットワークセッションが終わり，json解析がcompleteするまでweatherオブジェクトは得られずlabelには何も入らないので，普通に書くとアプリがクラッシュ．→ DispatchQueue.main.asyncブロックで囲む必要あり
//        
//        //DispatchQueue.main.asyncで囲むとmain threadで実行される（後で詳しく調べる）
//        //DispatchQueue.main.asyncはクロージャー
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = weather.tempretureString//クロージャー内なのでselfをつける
//            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
//            self.cityLabel.text = weather.cityName
//        }
//        //print(weather.tempreture)
//    }
//    
//    func didFailWithError(error: Error) {
//        print(error)//今回は単純にエラー文を出力するだけにした（ユーザには見えない）
//        //実際のアプリでは，エラーの内容ごとに，対処方法をユーザーに見せる
//        //ただ，今回の起こりうるエラーは，「json解析ができない」や「ネットワークエラー」なので，それらをユーザーに伝える必要はない．
//    }
//
//}
//
////MARK: - CLLocationManagerDelegate
//extension WeatherViewController: CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//}
//
