import Foundation

class Interactor {
    private let apiKey = "4d12877a1ef9ab64bdada1fa2263b7db"

    // Оновлений метод для запиту погодних даних
    func fetchWeatherData(for city: String, completion: @escaping (WeatherResponse?, String?) -> Void) {
        // Закодуйте місто перед відправкою запиту
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&units=metric&appid=\(apiKey)"
        
        // Вивести сформований URL для перевірки
        print("Weather API URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL for weather data")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            // Перевірка статусу HTTP-відповіді
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(nil, "Server error: \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                completion(nil, "No data received")
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(weatherResponse, nil)
            } catch {
                completion(nil, "Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Оновлений метод для запиту прогнозу погоди
    func fetchForecastData(for city: String, completion: @escaping (ForecastResponse?, String?) -> Void) {
        // Закодуйте місто перед відправкою запиту
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityEncoded)&units=metric&appid=\(apiKey)"
        
        // Вивести сформований URL для перевірки
        print("Forecast API URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL for forecast data")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            // Перевірка статусу HTTP-відповіді
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(nil, "Server error: \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                completion(nil, "No data received")
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecastResponse, nil)
            } catch {
                completion(nil, "Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Оновлений метод для запиту даних забруднення
    func fetchPollutionData(for city: String, completion: @escaping (PollutionResponse?, String?) -> Void) {
        // Спочатку отримуємо координати
        fetchCoordinates(for: city) { coordinates, error in
            guard let coordinates = coordinates, error == nil else {
                completion(nil, error)
                return
            }

            // Виконуємо запит на забруднення
            let pollutionUrlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(self.apiKey)"

            guard let url = URL(string: pollutionUrlString) else {
                completion(nil, "Invalid URL for pollution data")
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, "Error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, "Server error: \(response?.description ?? "Unknown error")")
                    return
                }

                guard let data = data else {
                    completion(nil, "No data received for pollution")
                    return
                }

                do {
                    let pollutionResponse = try JSONDecoder().decode(PollutionResponse.self, from: data)
                    completion(pollutionResponse, nil)
                } catch {
                    completion(nil, "Failed to decode pollution JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    }

    private func fetchCoordinates(for city: String, completion: @escaping (Coordinates?, String?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, "Server error: \(response?.description ?? "Unknown error")")
                return
            }

            guard let data = data else {
                completion(nil, "No data received")
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let coordinates = Coordinates(lat: weatherResponse.coord.lat, lon: weatherResponse.coord.lon)
                completion(coordinates, nil)
            } catch {
                completion(nil, "Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
