//
//  WeatherModel.swift
//  Clima
//
//  Created by Александр Х on 30.01.2023.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let feelsTemperature: Double
    let wind: Double
    
    var windString: String {
        return String(format: "%.1f", wind)
    }
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var feelsTempString: String {
        return String(format: "%.1f", feelsTemperature)
    }
    
    var conditionName: String {
        switch conditionID {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud"
                default:
                    return "cloud"
                }

    }
    
 
}
