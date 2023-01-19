//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 16/01/2023.
//

import Foundation
import RxRelay

class HomeViewModel {
	
	
	//MARK: - properties
	private let apiService = Network()
	public var currentWeatherResponse = PublishRelay<CurrentWeatherResponse>()
	public var weatherHistoryResponse = PublishRelay<WeatherHistoryResponseNew>()
	public var weatherListResponse = PublishRelay<[List1]>()
	public var errorResponse = PublishRelay<Errors>()
	
	
	//MARK: - NetworkCall
	func fetchCurrentWeather(lon: Double, lat: Double) {
		let url = "\(K.api.currentUrl)?lon=\(lon)&lat=\(lat)&units=metric"
		
		apiService.fetchData(url: url, method: .get, params: nil) { [weak self] (response: Result<CurrentWeatherResponse, Errors>) in
			switch response {
			case .success(let data):
				self?.currentWeatherResponse.accept(data)
				break
			case .failure(let error):
				self?.errorResponse.accept(error)
			}
		}
	}
	
	
	func fetchWeatherHistory(lon: Double, lat: Double) {
		let url = "\(K.api.historyUrl)?lon=\(lon)&lat=\(lat)&cnt=30&units=metric"
		
		apiService.fetchData(url: url, method: .get, params: nil) { [weak self] (response: Result<WeatherHistoryResponseNew, Errors>) in
			switch response {
			case .success(let data):
				self?.weatherListResponse.accept(removeDuplicateElements(data: data.list))
				break
			case .failure(let error):
				self?.errorResponse.accept(error)
			}
		}
	}
	
	
	
}
