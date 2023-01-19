//
//  Constants.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 16/01/2023.
//

import Foundation

struct K {
	struct api {
		static let apiKey = "9c18b8274c5df7877b104b13f033825b"
		static let baseUrl = "https://api.openweathermap.org/data/2.5/"
		static let historyUrl = "forecast"
		static let currentUrl = "weather"
	}
	
	struct strings {
		static let locationPermission = "This App requires location permission to get your current weather location, give this app location perission in your settings"
		static let networkMessage = "No internet connection, check your conectivity and try again"
		static let loadingMessage = "Please Wait..."
		static let txtRootedDevice = "Rooted Device Detected"
	}
	
	struct home {
		static let lblMax = "Max"
		static let lblCurrent = "Current"
		static let lblMin = "Min"
	}
	
	struct images {
		static let sea_cloudy = "sea_cloudy"
		static let sea_rainy = "sea_rainy"
		static let sea_sunny = "sea_sunny"
		static let partly_sunny = "partlysunny"
		static let rain = "rain"
		static let clear = "clear"
	}
	
	struct cells {
		static let history_cell = "cell"
	}
}
