//
//  WeatherHistoryResponseNew.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 16/01/2023.
//

import Foundation

// MARK: - Welcome
struct WeatherHistoryResponseNew: Codable {
	let cod: String?
	let message: Int
	let cnt: Int
	let list: [List1]
	let city: City
}


// MARK: - List
struct List1: Codable {
	let dt: Int
	let main: Main1
	let weather: [Weather]
	let clouds: Clouds
	let wind: Wind
	let visibility: Int
	let pop: Double
	let rain: Rain?
	let sys: Sys
	var dtTxt: String

	enum CodingKeys: String, CodingKey {
		case dt, main, weather, clouds, wind, visibility, pop, rain, sys
		case dtTxt = "dt_txt"
	}

}


// MARK: - Main
struct Main1: Codable {
	let temp, feelsLike, tempMin, tempMax: Double
	let pressure, seaLevel, grndLevel, humidity: Int
	let tempKf: Double

	enum CodingKeys: String, CodingKey {
		case temp
		case feelsLike = "feels_like"
		case tempMin = "temp_min"
		case tempMax = "temp_max"
		case pressure
		case seaLevel = "sea_level"
		case grndLevel = "grnd_level"
		case humidity
		case tempKf = "temp_kf"
	}
}

