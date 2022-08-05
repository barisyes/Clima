//
//  WeatherManager.swift
//  Clima
//
//  Created by Barış Yeşilkaya on 28.07.2022.
//  

import Foundation
import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=096aca5a6ebfd3a3b66493ce5efc893f&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lon=\(longitude)&lat=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1.Create a URL
        if let url = URL(string: urlString){
            
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give URLSession a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4.Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedDate = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedDate.weather[0].id
            let temp = decodedDate.main.temp
            let name = decodedDate.name
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
