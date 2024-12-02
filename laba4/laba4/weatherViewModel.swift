import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var errorMessage: String?

    private let interactor = Interactor()

    // Викликаємо обидва запити одночасно
    func fetchWeather(for city: String) {
        interactor.fetchWeatherData(for: city) { response, error in
            if let error = error {
                self.errorMessage = error
            } else {
                self.weather = response
                self.forecast = nil // очищуємо прогноз при запиті поточної погоди
            }
        }
    }

    func fetchForecast(for city: String) {
        interactor.fetchForecastData(for: city) { response, error in
            if let error = error {
                self.errorMessage = error
            } else {
                self.forecast = response
                self.weather = nil // очищуємо поточну погоду при запиті прогнозу
            }
        }
    }
}
