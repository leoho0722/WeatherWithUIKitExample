import Foundation

struct WeatherDataResponse: Decodable {
    var name: String
    var id: Int
    var dt: TimeInterval

    var coord: Coord
    var main: Main
    var weather: [Weather]
    
    struct Coord: Decodable {
        var lon: Double // 經度
        var lat: Double // 緯度
    }

    struct Main: Decodable {
        var temp: Double
        var temp_min: Double
        var temp_max: Double
        var humidity: Int
    }

    struct Weather: Decodable {
        var icon: String
        var main: String
        var description: String
    }
}
