import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var selectBtn:UIButton!
    @IBOutlet weak var selectedCityLabel:UILabel!
    @IBOutlet weak var beginSearchBtn:UIButton!
    @IBOutlet weak var cityPicker:UIPickerView!
    @IBOutlet weak var pickerViewShow: NSLayoutConstraint!
    @IBOutlet weak var cityBarItem: UITabBarItem!
    
    var selectedCity:String = ""
    var weatherTemp = [String]()
    var weatherResult:String? = nil
    let cityList = ["Taipei","New Taipei","Taoyuan","Taichung","Tainan","Kaohsiung","New York"]
    let cityListURL = ["Taipei","New%20Taipei","Taoyuan","Taichung","Tainan","Kaohsiung","New%20York"]

    override func viewDidLoad() {
        super.viewDidLoad()
        cityPicker.delegate = self
        cityPicker.dataSource = self
    }
    
    //MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //有幾列
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityList.count // 可選取的城市數量
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cityListURL[row]
        switch cityListURL[row] {
            case "Taipei": selectedCityLabel.text = "台北"
            case "New%20Taipei": selectedCityLabel.text = "新北"
            case "Taoyuan": selectedCityLabel.text = "桃園"
            case "Taichung": selectedCityLabel.text = "台中"
            case "Tainan": selectedCityLabel.text = "台南"
            case "Kaohsiung": selectedCityLabel.text = "高雄"
            case "New%20York": selectedCityLabel.text = "紐約"
            default: selectedCityLabel.text = "尚未選取到城市"
        }
    }
    
    func isPickerViewShow(_ input: Bool) {
        if (input) {
            pickerViewShow.constant = -50 //跳出 Picker View
        }else{
            pickerViewShow.constant = 200 //關閉 Picker View
        }
    }
    
    //MARK: - 取得天氣資料
    
    func getWeatherData(city:String) {
        weatherTemp = []
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        if let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) {
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
                            self.weatherTemp.append(self.selectedCityLabel.text!)
                            self.weatherTemp.append(String(weatherData.coord.lon))
                            self.weatherTemp.append(String(weatherData.coord.lat))
                            self.weatherTemp.append(String(Int(weatherData.main.temp)/10)+"°C")
                            self.weatherTemp.append(String(weatherData.main.humidity)+"%")
                            self.weatherResult = "城市名稱：\(self.weatherTemp[0])\n經度：\(self.weatherTemp[1])\n緯度：\(self.weatherTemp[2])\n目前溫度：\(self.weatherTemp[3])\n目前濕度：\(self.weatherTemp[4])"
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
    
    @IBAction func selectCity(_ sender: UIButton) {
        isPickerViewShow(true)
    }
    
    @IBAction func beginSearch(_ sender: Any) {
        getWeatherData(city: selectedCity)
        isPickerViewShow(false)
    }
    
}

//MARK: - 參考來源

//Swift API 教學
//Swift — 說說 Codable （ Decodable & Encodable）
//https://medium.com/@JJeremy.XUE/swift-%E8%AA%AA%E8%AA%AA-codable-decodable-encodable-594b28ff3d49
//Swift — 來接個 API 吧（ API & JSON ）
//https://medium.com/@JJeremy.XUE/swift-%E4%BE%86%E6%8E%A5%E5%80%8B-api-%E5%90%A7-open-data-a639beeea5cb
//Swift — 來接個 API 吧（ 串接 API & 解析 JSON ）
//https://medium.com/@JJeremy.XUE/swift-%E4%BE%86%E6%8E%A5%E5%80%8B-api-%E5%90%A7-%E4%B8%B2%E6%8E%A5-api-%E8%A7%A3%E6%9E%90-json-b9ea320f674e
//"Modifications to the layout engine must not be performed from a background thread after it has been accessed from the main thread." 解法
//https://stackoom.com/question/3vjDk/%E4%BB%8E%E4%B8%BB%E7%BA%BF%E7%A8%8B%E8%AE%BF%E9%97%AE%E5%90%8E-%E4%B8%8D%E5%BE%97%E4%BB%8E%E5%90%8E%E5%8F%B0%E7%BA%BF%E7%A8%8B%E5%AF%B9-gt-%E5%B8%83%E5%B1%80%E5%BC%95%E6%93%8E%E8%BF%9B%E8%A1%8C%E4%BF%AE%E6%94%B9
//https://github.com/gmawji/ios10-artwork
