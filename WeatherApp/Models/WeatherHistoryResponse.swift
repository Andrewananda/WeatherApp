//
//  WeatherHistoryResponse.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 16/01/2023.
//

import Foundation

struct WeatherHistoryResponse: Codable {
	let city: City
	let cod: String
	let message: Double
	let cnt: Int
	let list: [List]?
}

// MARK: - City
struct City: Codable {
	let id: Int
	let name: String
	let coord: Coord
	let country: String
	let population, timezone: Int
}


// MARK: - List
struct List: Codable {
	let dt, sunrise, sunset: Int?
	let temp: Temp?
	let feelsLike: FeelsLike?
	let pressure, humidity: Int?
	let weather: [Weather]
	let speed: Double?
	let deg: Int?
	let gust: Double?
	let clouds: Int?
	let pop, rain: Double?

	enum CodingKeys: String, CodingKey {
		case dt, sunrise, sunset, temp
		case feelsLike = "feels_like"
		case pressure, humidity, weather, speed, deg, gust, clouds, pop, rain
	}
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
	let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
	let day, min, max, night: Double
	let eve, morn: Double
}
