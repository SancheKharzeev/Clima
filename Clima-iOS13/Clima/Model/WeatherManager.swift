//
//  WeatherManager.swift
//  Clima
//
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5e630bce49e6a1ca2fecf7f80c25bbb4&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    
    func fetchWeather(cityName: String) { // объединение ссылки погоды и города
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: Double, longitude: Double) { // объединение ссылки погоды и города
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print("\(urlString) lat lon")
  
    }
    
    func performRequest(with urlString: String) { // выполняем запрос
        // создаем URL
        
        if let url = URL(string: urlString) { // с проверкой на нил. проверка существования значения в необязательном параметре.
            let session = URLSession(configuration: .default)
            // give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in //  dataTask нужна чтобы получать развернутый ответ с параметрами (температура погода облачность) Здесь сделали Замыкание
                if error != nil { // если error не равен нулю, то есть ошибка есть тогда печатаем что ошибка
                    delegate?.didFailWithError(error: error!) // поставить в начале self
                    return
                }
                // если ошибки нет, то идем дальше и сохраняем данные из data
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather) 
                       
                    }
                }
        }
        task.resume() //запускает задание task, После создания задачи ее необходимо запустить, вызвав ее resume()метод.
    }
}
func parseJSON(_ weatherData: Data) -> WeatherModel? { // извлекаем данные
    let decoder = JSONDecoder() // присваеваем переменной декодер метод JSONDecoder чтобы декодировать
    do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // decode - Returns a value of the type you specify, decoded from a JSON object. этот метод может вызывать ошибку поэтому добавляют try, do, catch
        let name = decodedData.name
        let temp = decodedData.main.temp
        let id = decodedData.weather[0].id
        let feelsTemp = decodedData.main.feels_like
        let wind = decodedData.wind.speed
        
        let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, feelsTemperature: feelsTemp, wind: wind)
        
        return weather
       
        
        
    } catch {
        delegate?.didFailWithError(error: error)
        return nil
    }
}


}

