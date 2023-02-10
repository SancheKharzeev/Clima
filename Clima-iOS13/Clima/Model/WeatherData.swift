//
//  WeatherData.swift
//  Clima
//
//  Created by Александр Х on 27.01.2023.
//

import Foundation

struct WeatherData: Codable { // добавили тип Codable который может декодировать себя из внешнего представления и обратно
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}
struct Main: Codable {
    let temp: Double
    let feels_like: Double
}
struct Weather: Codable {
    let description: String
    let id: Int
}
struct Wind: Codable {
    let speed: Double
}
