import Foundation

// Структура для координат
struct Coordinates {
    let lat: Double
    let lon: Double
}

// Структура для основних погодних даних
struct WeatherResponse: Codable {
    let coord: CoordinatesResponse
    let main: MainWeather
    let weather: [WeatherDescription]
}

// Структура для координат відповіді
struct CoordinatesResponse: Codable {
    let lat: Double
    let lon: Double
}

// Структура для основних погодних характеристик (температура, вологість)
struct MainWeather: Codable {
    let temp: Double
    let humidity: Double
}

// Структура для опису погодних умов
struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// Структури для даних про забруднення повітря
struct PollutionResponse: Codable {
    let list: [PollutionData]
}

struct PollutionData: Codable {
    let main: PollutionMain
    let components: PollutionComponents
}

struct PollutionMain: Codable {
    let aqi: Int // Індекс якості повітря
}

struct PollutionComponents: Codable {
    let co: Double? // Моноксид вуглецю
    let no: Double? // Оксид азоту
    let no2: Double? // Двоокис азоту
    let o3: Double? // Озон
    let so2: Double? // Двоокис сірки
    let pm2_5: Double? // PM2.5
    let pm10: Double? // PM10
    let nh3: Double? // Амміак
}




// Структури для прогнозу погоди

// Структура для відповіді прогнозу
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

// Структура для кожного пункту прогнозу
struct ForecastItem: Codable {
    let dt: Int
    let dt_txt: String
    let main: MainWeather
    let weather: [WeatherDescription]
}

