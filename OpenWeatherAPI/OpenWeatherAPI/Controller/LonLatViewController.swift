import UIKit

class LonLatViewController: UIViewController {

    @IBOutlet weak var lonlatTabBarItem: UITabBarItem!
    @IBOutlet weak var searchCityLabel: UILabel!
    @IBOutlet weak var cityLonTextField: UITextField! // 經度
    @IBOutlet weak var cityLatTextField: UITextField! // 緯度
    
    var weatherTemp: [String] = []
    var weatherResult: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCloseBtnOnKeyBoard()
    }
    
    // MARK: - 在鍵盤上新增 Button
    
    func addCloseBtnOnKeyBoard() {
        let doneBtn = UIBarButtonItem(title: "關閉", style: .done, target: self, action: #selector(closeBtnAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolBar.barStyle = .default
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(doneBtn)
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        self.cityLonTextField.inputAccessoryView = doneToolBar
        self.cityLatTextField.inputAccessoryView = doneToolBar
    }
    @objc func closeBtnAction() {
        self.cityLonTextField.resignFirstResponder()
        self.cityLatTextField.resignFirstResponder()
    }

    // MARK: - 取得天氣資料
    
    func getWeatherDataWithLonLat(lon: Double, lat: Double) {
        weatherTemp = []
        if #available(iOS 15.0, *) {
            Task {
                do {
                    let weatherData: WeatherDataResponse = try await NetworkManager.shared.requestData(lon: lon, lat: lat)
                    DispatchQueue.main.async {
                        self.weatherTemp.append(weatherData.name)
                        self.weatherTemp.append(String(weatherData.coord.lon))
                        self.weatherTemp.append(String(weatherData.coord.lat))
                        self.weatherTemp.append(String(Int(weatherData.main.temp)/10)+"°C")
                        self.weatherTemp.append(String(weatherData.main.humidity)+"%")
                        self.weatherResult = "城市名稱：\(self.weatherTemp[0])\n經度：\(self.weatherTemp[1])\n緯度：\(self.weatherTemp[2])\n目前溫度：\(self.weatherTemp[3])\n目前濕度：\(self.weatherTemp[4])"
                        print(self.weatherResult ?? "查無資料")
                        self.alert(title:"天氣查詢結果", message: self.weatherResult ?? "查無資料")
                    }
                } catch NetworkManager.WeatherDataFetchError.invalidURL {
                    print("無效的 URL")
                } catch NetworkManager.WeatherDataFetchError.requestFailed {
                    print("Request Error")
                } catch NetworkManager.WeatherDataFetchError.responseFailed {
                    print("Response Error")
                } catch NetworkManager.WeatherDataFetchError.jsonDecodeFailed {
                    print("JSON Decode 失敗")
                }
            }
        } else if #available(iOS 14.0, *) {
            NetworkManager.shared.requestData(lon: lon, lat: lat) { (result: Result<WeatherDataResponse, NetworkManager.WeatherDataFetchError>) in
                switch result {
                case .success(let weatherData):
                    DispatchQueue.main.async {
                        self.weatherTemp.append(weatherData.name)
                        self.weatherTemp.append(String(weatherData.coord.lon))
                        self.weatherTemp.append(String(weatherData.coord.lat))
                        self.weatherTemp.append(String(Int(weatherData.main.temp)/10)+"°C")
                        self.weatherTemp.append(String(weatherData.main.humidity)+"%")
                        self.weatherResult = "城市名稱：\(self.weatherTemp[0])\n經度：\(self.weatherTemp[1])\n緯度：\(self.weatherTemp[2])\n目前溫度：\(self.weatherTemp[3])\n目前濕度：\(self.weatherTemp[4])"
                        print(self.weatherResult ?? "查無資料")
                        self.alert(title:"天氣查詢結果", message: self.weatherResult ?? "查無資料")
                    }
                case.failure(let fetchError):
                    switch fetchError {
                    case .invalidURL:
                        print("無效的 URL")
                    case .requestFailed:
                        print("Request Error")
                    case .responseFailed:
                        print("Response Error")
                    case .jsonDecodeFailed:
                        print("JSON Decode 失敗")
                    }
                }
            }
        } else {
            NetworkManager.shared.requestData(lon: lon, lat: lat) { (weatherData: WeatherDataResponse?) in
                
                guard let name = weatherData?.name else { return }
                guard let coordLon = weatherData?.coord.lon else { return }
                guard let coordLat = weatherData?.coord.lat else { return }
                guard let temp = weatherData?.main.temp else { return }
                guard let humidity = weatherData?.main.humidity else { return }
                
                DispatchQueue.main.async {
                    self.weatherTemp.append(name)
                    self.weatherTemp.append(String(coordLon))
                    self.weatherTemp.append(String(coordLat))
                    self.weatherTemp.append(String(Int(temp)/10)+"°C")
                    self.weatherTemp.append(String(humidity)+"%")
                    self.weatherResult = "城市名稱：\(self.weatherTemp[0])\n經度：\(self.weatherTemp[1])\n緯度：\(self.weatherTemp[2])\n目前溫度：\(self.weatherTemp[3])\n目前濕度：\(self.weatherTemp[4])"
                    print(self.weatherResult ?? "查無資料")
                    self.alert(title:"天氣查詢結果", message: self.weatherResult ?? "查無資料")
                }
            } failure: { weatherFetchError in
                switch weatherFetchError {
                case .invalidURL:
                    print("無效的 URL")
                case .requestFailed:
                    print("Request Error")
                case .responseFailed:
                    print("Response Error")
                case .jsonDecodeFailed:
                    print("JSON Decode 失敗")
                }
            }
        }
    }
    
    // MARK: - 天氣查詢結果以訊息框方式跳出
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default, handler: nil)
        alertController.addAction(closeAction)
        present(alertController,animated: true)
    }
    
    // MARK: - @IBAction 元件
    
    @IBAction func beginSearch(_ sender: Any) {
        if (cityLonTextField.text == "" || cityLatTextField.text == "") {
            self.alert(title: "", message: "請輸入經緯度")
        } else {
            self.getWeatherDataWithLonLat(lon: Double(cityLonTextField.text!)!, lat: Double(cityLatTextField.text!)!)
        }
    }
}

// MARK: - 參考來源

/**
1. 在鍵盤上加入按鈕
https://mini.nidbox.com/diary/read/9586569
 
 */
