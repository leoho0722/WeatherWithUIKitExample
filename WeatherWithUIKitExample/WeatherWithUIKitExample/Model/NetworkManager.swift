//
//  WeatherAPI Service.swift
//  MVVM Demo
//
//  Created by Leo Ho on 2022/4/21.
//  Copyright © 2022 Leo Ho. All rights reserved.
//

import Foundation

typealias Response<D> = Result<D, NetworkManager.WeatherDataFetchError> where D: Decodable

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    enum WeatherDataFetchError: Error {
        case invalidURL
        case requestFailed
        case responseFailed
        case jsonDecodeFailed
    }
    
    // MARK: - 取得天氣資料 (城市名稱)
    
    /// 取得天氣資料 (城市名稱)
    func requestData<D>(city: String,
                        success: @escaping (D) -> Void,
                        failure: @escaping (WeatherDataFetchError) -> Void) where D: Decodable {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
            failure(.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("Request Error: \(String(describing: error?.localizedDescription))")
                failure(.requestFailed)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ... 299).contains(response.statusCode),
                  let data = data else {
                print("Response Error: \(String(describing: error?.localizedDescription))")
                failure(.responseFailed)
                return
            }
            print("Status Code: \(response.statusCode)")
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(D.self, from: data) else {
                failure(.jsonDecodeFailed)
                return
            }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            success(weatherData)
        }.resume()
    }
    
    /// 取得天氣資料 (城市名稱) with Result type
    @available(iOS 14.0, *)
    @available(swift 5.0)
    func requestData<D>(city: String,
                        completion: @escaping (Result<D, WeatherDataFetchError>) -> Void) where D: Decodable {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ... 299).contains(response.statusCode),
                  let data = data else {
                completion(.failure(.responseFailed))
                return
            }
            print("Status Code: \(response.statusCode)")
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(D.self, from: data) else {
                completion(.failure(.jsonDecodeFailed))
                return
            }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            completion(.success(weatherData))
        }.resume()
    }
    
    /// 取得天氣資料 (城市名稱) async
    @available(iOS 15.0, *)
    @available(swift 5.5)
    func requestData<D>(city: String) async throws -> D where D: Decodable {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "q=\(city)" + "&appid=" + apikey) else {
            throw WeatherDataFetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200 ... 299).contains(response.statusCode) else {
            throw WeatherDataFetchError.responseFailed
        }
        print("Status Code: \(response.statusCode)")
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(D.self, from: data) else {
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
    func requestData<D>(lon: Double,
                       lat: Double,
                       success: @escaping (D) -> Void,
                       failure: @escaping (WeatherDataFetchError) -> Void) where D: Decodable {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
            failure(.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("Request Error: \(String(describing: error?.localizedDescription))")
                failure(.requestFailed)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ... 299).contains(response.statusCode),
                  let data = data else {
                print("Response Error: \(String(describing: error?.localizedDescription))")
                failure(.responseFailed)
                return
            }
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(D.self, from: data) else { return }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            success(weatherData)
        }.resume()
    }
    
    /// 取得天氣資料 (經緯度) with Result type
    @available(iOS 14.0, *)
    @available(swift 5.0)
    func requestData<D>(lon: Double,
                        lat: Double,
                        completion: @escaping (Result<D, WeatherDataFetchError>) -> Void) where D: Decodable {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ... 299).contains(response.statusCode),
                  let data = data else {
                completion(.failure(.responseFailed))
                return
            }
            
            let decoder = JSONDecoder()
            guard let weatherData = try? decoder.decode(D.self, from: data) else {
                completion(.failure(.jsonDecodeFailed))
                return
            }
            
            #if DEBUG
            print("============== Weather Data ==============")
            print(weatherData)
            print("============== Weather Data ==============")
            #endif
            
            completion(.success(weatherData))
        }.resume()
    }
    
    /// 取得天氣資料 (經緯度) async
    @available(iOS 15.0, *)
    @available(swift 5.5)
    func requestData<D>(lon: Double, lat: Double) async throws -> D where D: Decodable {
        let address = "https://api.openweathermap.org/data/2.5/weather?"
        let apikey = "62ef5eba4eeb4662491645f8f68cc219"
        
        guard let url = URL(string: address + "lat=\(lat)" + "&lon=\(lon)" + "&appid=" + apikey) else {
            throw WeatherDataFetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200 ... 299).contains(response.statusCode) else {
            throw WeatherDataFetchError.responseFailed
        }
        
        let decoder = JSONDecoder()
        guard let weatherData = try? decoder.decode(D.self, from: data) else {
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
