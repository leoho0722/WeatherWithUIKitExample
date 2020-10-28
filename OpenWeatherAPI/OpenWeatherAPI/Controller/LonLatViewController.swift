import UIKit

class LonLatViewController: UIViewController {

    @IBOutlet weak var lonlatTabBarItem: UITabBarItem!
    @IBOutlet weak var searchCityLabel: UILabel!
    @IBOutlet weak var cityLonTextField: UITextField! //經度
    @IBOutlet weak var cityLatTextField: UITextField! //緯度
    
    var weatherTemp = [String]()
    var weatherResult:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCloseBtnOnKeyBoard()
    }
    
    //MARK: - 在鍵盤上新增 Button
    
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

    //MARK: - 取得天氣資料
    
    func getWeatherDataWithLonLat(lon:Double, lat:Double) {
        weatherTemp = []
        let address = "http://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        if let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error:\(error.localizedDescription)")
                }else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code:\(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) {
                        print("============== Weather Data ==============")
                        print(weatherData)
                        print("============== Weather Data ==============")
                        DispatchQueue.main.async {
                            self.weatherTemp.append(weatherData.name)
                            self.weatherTemp.append(String(weatherData.coord.lon))
                            self.weatherTemp.append(String(weatherData.coord.lat))
                            self.weatherTemp.append(String(Int(weatherData.main.temp)/10)+"°C")
                            self.weatherTemp.append(String(weatherData.main.humidity)+"%")
                            self.weatherResult = "城市名稱：\(self.weatherTemp[0])\n經度：\(self.weatherTemp[1])\n緯度：\(self.weatherTemp[2])\n目前溫度：\(self.weatherTemp[3])\n目前濕度：\(self.weatherTemp[4])"
                            self.searchCityLabel.text = self.weatherTemp[0]
                            print(self.weatherResult ?? "查無資料")
                            self.alert(title:"天氣查詢結果", message: self.weatherResult ?? "查無資料")
                        }
                    }
                }
            }.resume()
        }else{
            print("無效的 URL")
        }
    }
    
    //MARK: - 天氣查詢結果以訊息框方式跳出
    
    func alert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default, handler: nil)
        alertController.addAction(closeAction)
        present(alertController,animated: true)
    }
    
    //MARK: - @IBAction 元件
    
    @IBAction func beginSearch(_ sender: Any) {
        if (cityLonTextField.text == "" || cityLatTextField.text == "") {
            self.alert(title: "", message: "請輸入經緯度")
        }else{
            self.getWeatherDataWithLonLat(lon: Double(cityLonTextField.text!)!, lat: Double(cityLatTextField.text!)!)
        }
    }
}

//MARK: - 參考來源

//在鍵盤上加入按鈕
//https://mini.nidbox.com/diary/read/9586569
