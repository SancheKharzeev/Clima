//
//  ViewController.swift
//  Clima
//
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var feelsTemperature: UILabel!
    @IBOutlet weak var descrWeather: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    
    
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    
        
        super.viewDidLoad()
        weatherManager.delegate = self // устанавливаем текущий класс в качестве делегата
        searchTextField.delegate = self // говорит о том что searchTextField должен теперь передавать данные в WeatherViewController когда начал печатать, когда закончил
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate { // выделили отдельно все функции относящиеся к протоколу UITextFieldDelegate через расширение
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
       // textFieldShouldClear(searchTextField)
        
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // метод позволяет обрабатывать код после нажатия кнопки Return на клавиатуре
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { // метод передаст название города в структуру weatherManager.fetchWeather после окончания ввода текста
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = "" // затем поле очистится
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // разрешает закончить редактировать поле
        if textField.text != "" {  // если поле textField не пустое, то возвращается значение true и дает пользователю закончить редактировать поле, если поле не заполнено, то в поле появится надпись пожалуйста введите название города и не даст закончить редактирование поля
            return true
        } else {
            textField.placeholder = "Enter the city name"
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.feelsTemperature.text = weather.feelsTempString
            self.descrWeather.text = weather.windString
            print(weather.wind)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Location data received.")
            print(location)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    @IBAction func currentLocatPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    
    
}
