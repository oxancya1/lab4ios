import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""
    @State private var selectedViewOption: ViewOption = .currentWeather

    // Перерахування для вибору виду погоди
    enum ViewOption: String, CaseIterable {
        case currentWeather = "Current Weather"
        case forecast = "Forecast"
    }

    var body: some View {
        VStack {
            Text("Weather App")
                .bold()
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
            
            // Перемикач для вибору між поточною погодою та прогнозом
            Picker("Select Weather Type", selection: $selectedViewOption) {
                ForEach(ViewOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Показуємо поточну погоду
            if selectedViewOption == .currentWeather {
                if let weather = viewModel.weather {
                    VStack(spacing: 10) {
                        HStack {
                            Text("\(Int(round(weather.main.temp)))")
                                .font(.system(size: 36, weight: .bold))
                            Text("°C")
                                .font(.system(size: 36, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        Text("Description: \(weather.weather.first?.description.capitalized ?? "")")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .padding()
                }
            }

            // Показуємо прогноз погоди
            if selectedViewOption == .forecast {
                if let forecast = viewModel.forecast {
                    VStack {
                        ForEach(forecast.list.prefix(5), id: \.dt) { item in
                            HStack {
                                Text("\(item.dt_txt)")
                                Spacer()
                                Text("\(Int(round(item.main.temp)))°C")
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .padding()
                }
            }

            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Get Weather") {
                if selectedViewOption == .currentWeather {
                    viewModel.fetchWeather(for: city)
                } else if selectedViewOption == .forecast {
                    viewModel.fetchForecast(for: city)
                }
            }
            .padding()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}
