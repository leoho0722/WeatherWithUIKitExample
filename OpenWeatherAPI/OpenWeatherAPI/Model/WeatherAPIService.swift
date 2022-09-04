//
//  WeatherAPI Service.swift
//  MVVM Demo
//
//  Created by Leo Ho on 2022/4/21.
//  Copyright © 2022 Leo Ho. All rights reserved.
//

import Foundation

class WeatherAPIService: NSObject {
    
    static let shared = WeatherAPIService()
    
    enum WeatherDataFetchError: Error {
        case invalidURL
        case requestFailed
        case responseFailed
        case jsonDecodeFailed
    }
    
    // MARK: - 取得天氣資料 (城市名稱)
    
    /// 取得天氣資料 (城市名稱)
    func getWeatherData(city: String, success: @escaping (CurrectWeatherData) -> Void, failure: @escaping (WeatherDataFetchError) -> Void) {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
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
            guard let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) else { return }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            success(weatherData) // 將 API Response 的資料結構 (Model) 也就是 WeatherData，透過 Closure 回傳給 ViewModel
        }.resume()
    }
    
    /// 取得天氣資料 (城市名稱) with Result type
    @available(iOS 14.0, *)
    @available(swift 5.0)
    func getWeatherData(city: String, completion: @escaping (Result<CurrectWeatherData, WeatherDataFetchError>) -> Void) {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
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
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(.failure(.responseFailed))
                return
            }
            print("Status Code: \(response.statusCode)")
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) else {
                completion(.failure(.jsonDecodeFailed))
                return
            }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            completion(.success(weatherData)) // 將 API Response 的資料結構 (Model) 也就是 WeatherData，透過 Closure 回傳給 ViewModel
        }.resume()
    }
    
    /// 取得天氣資料 (城市名稱) async
    @available(iOS 15.0, *)
    @available(swift 5.5)
    func getWeatherData(city: String) async throws -> CurrectWeatherData {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
            throw WeatherDataFetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw WeatherDataFetchError.responseFailed
        }
        print("Status Code: \(response.statusCode)")
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) else {
            throw WeatherDataFetchError.jsonDecodeFailed
        }
        
        #if DEBUG
        print("============== Weather Data ==============")
        print(weatherData)
        print("============== Weather Data ==============")
        #endif
        
        return weatherData
    }
    
    // MARK: - 取得天氣資料 (經緯度)
    
    /// 取得天氣資料 (經緯度)
    func getWeatherData(lon: Double, lat: Double, success: @escaping (CurrectWeatherData) -> Void, failure: @escaping (WeatherDataFetchError) -> Void) {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
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
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                print("Response Error: \(error?.localizedDescription)")
                failure(.responseFailed)
                return
            }
            print("Status Code: \(response.statusCode)")
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) else { return }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            success(weatherData) // 將 API Response 的資料結構 (Model) 也就是 WeatherData，透過 Closure 回傳給 ViewModel
        }.resume()
    }
    
    /// 取得天氣資料 (經緯度) with Result type
    @available(iOS 14.0, *)
    @available(swift 5.0)
    func getWeatherData(lon: Double, lat: Double, completion: @escaping (Result<CurrectWeatherData, WeatherDataFetchError>) -> Void) {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
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
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(.failure(.responseFailed))
                return
            }
            print("Status Code: \(response.statusCode)")
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) else {
                completion(.failure(.jsonDecodeFailed))
                return
            }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            completion(.success(weatherData)) // 將 API Response 的資料結構 (Model) 也就是 WeatherData，透過 Closure 回傳給 ViewModel
        }.resume()
    }
    
    /// 取得天氣資料 (經緯度) async
    @available(iOS 15.0, *)
    @available(swift 5.5)
    func getWeatherData(lon: Double, lat: Double) async throws -> CurrectWeatherData {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
            throw WeatherDataFetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw WeatherDataFetchError.responseFailed
        }
        print("Status Code: \(response.statusCode)")
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(CurrectWeatherData.self, from: data) else {
            throw WeatherDataFetchError.jsonDecodeFailed
        }
        
        #if DEBUG
        print("============== Weather Data ==============")
        print(weatherData)
        print("============== Weather Data ==============")
        #endif
        
        return weatherData
    }
}
