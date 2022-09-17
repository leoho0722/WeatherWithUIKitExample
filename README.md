# OpenWeatherAPI

## Description

iOS App 開發練習 − 天氣 API 練習

開發語言：Swift 5

開發環境：Xcode 14.0

App 最低安裝限制：iOS 13.0

API 來源：OpenWeather

## WeatherDataFetchError

```swift
enum WeatherDataFetchError: Error {
    case invalidURL
    case requestFailed
    case responseFailed
    case jsonDecodeFailed
}
```

## Overwritten with Generic

### General

#### Input City Name

```swift
func requestData<D: Decodable>(city: String, success: @escaping (D?) -> Void, failure: @escaping (WeatherDataFetchError) -> Void) {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
        failure(.invalidURL)
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil else {
            print("Request Error: \(error?.localizedDescription)")
            failure(.requestFailed)
            return
        }
        
        guard let response = response as? HTTPURLResponse, let data = data else {
            print("Response Error: \(error?.localizedDescription)")
            failure(.responseFailed)
            return
        }
        print("Status Code: \(response.statusCode)")
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(D.self, from: data) else {
            failure(.jsonDecodeFailed)
            return
        }
        
        success(weatherData)
    }.resume()
}
```

#### Input Lon、Lat

```swift
func requestData<D: Decodable>(lon: Double, lat: Double, success: @escaping (D?) -> Void, failure: @escaping (WeatherDataFetchError) -> Void) {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
        failure(.invalidURL)
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil else {
            print("Request Error: \(error?.localizedDescription)")
            failure(.requestFailed)
            return
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
            print("Response Error: \(error?.localizedDescription)")
            failure(.responseFailed)
            return
        }
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(D.self, from: data) else { return }
        
        success(weatherData)
    }.resume()
}
```

### Result type

#### Input City Name

```swift
@available(iOS 14.0, *)
@available(swift 5.0)
func requestData<D: Decodable>(city: String, completion: @escaping (Result<D, WeatherDataFetchError>) -> Void) {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
        completion(.failure(.invalidURL))
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil else {
            print("Error: \(error?.localizedDescription)")
            completion(.failure(.requestFailed))
            return
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
            completion(.failure(.responseFailed))
            return
        }
        print("Status Code: \(response.statusCode)")
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(D.self, from: data) else {
            completion(.failure(.jsonDecodeFailed))
            return
        }
        
        completion(.success(weatherData))
    }.resume()
}
```

#### Input Lon、Lat

```swift
@available(iOS 14.0, *)
@available(swift 5.0)
func requestData<D: Decodable>(lon: Double, lat: Double, completion: @escaping (Result<D, WeatherDataFetchError>) -> Void) {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
        completion(.failure(.invalidURL))
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil else {
            print("Error: \(error?.localizedDescription)")
            completion(.failure(.requestFailed))
            return
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
            completion(.failure(.responseFailed))
            return
        }
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(D.self, from: data) else {
            completion(.failure(.jsonDecodeFailed))
            return
        }
        
        completion(.success(weatherData))
    }.resume()
}
```

### await/async

#### Input City Name

```swift
@available(iOS 15.0, *)
@available(swift 5.5)
func requestData<D: Decodable>(city: String) async throws -> D {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
        throw WeatherDataFetchError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw WeatherDataFetchError.responseFailed
    }
    print("Status Code: \(response.statusCode)")
    
    let decoder = JSONDecoder()
    guard let weatherData = try? decoder.decode(D.self, from: data) else {
        throw WeatherDataFetchError.jsonDecodeFailed
    }
    
    return weatherData
}
```

#### Input Lon、Lat

```swift
@available(iOS 15.0, *)
@available(swift 5.5)
func requestData<D: Decodable>(lon: Double, lat: Double) async throws -> D {
    let address = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "YOUR_API_KEY"
    
    guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
        throw WeatherDataFetchError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw WeatherDataFetchError.responseFailed
    }
    
    let decoder = JSONDecoder()
    guard let weatherData = try? decoder.decode(D.self, from: data) else {
        throw WeatherDataFetchError.jsonDecodeFailed
    }
    
    return weatherData
}
```
