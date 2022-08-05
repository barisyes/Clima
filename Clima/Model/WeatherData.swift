//
//  WeatherData.swift
//  Clima
//
//  Created by Barış Yeşilkaya on 1.08.2022.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]

}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}

