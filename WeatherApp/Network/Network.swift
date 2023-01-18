//
//  Network.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 16/01/2023.
//

import Foundation
import Alamofire


class Network {
	
	
	func fetchData<T: Codable>(url: String, method: HTTPMethod, params:[String: Any]?, completion: @escaping (Result<T, Errors>) -> Void) {
			
		let endpoint = K.api.baseUrl + url + "&appid=\(K.api.apiKey)"
								
			
		AF.request(endpoint, method: method, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
				.validate(statusCode: 200..<300).response { response in
					
					if let httpUrlResponse = response.response, 200..<300 ~= httpUrlResponse.statusCode {
						guard let processData = response.data else {
							completion(.failure(Errors.emptyResponse("Unable to process request")))
							return
						}
						
						do {
							let decoder = JSONDecoder()
							decoder.dataDecodingStrategy = .base64
							completion(.success(try decoder.decode(T.self, from: processData)))
							DispatchQueue.main.async(execute: {
							  })
						} catch(let error) {
							print(T.self)
							completion(.failure(Errors.apiError(error.localizedDescription)))
						}
						
						
						do {
							let decoder = JSONDecoder()
							decoder.dataDecodingStrategy = .base64
							completion(.success(try decoder.decode(T.self, from: processData)))
							DispatchQueue.main.async(execute: {
							  })
						}  catch let DecodingError.dataCorrupted(context) {
							print(context)
						} catch let DecodingError.keyNotFound(key, context) {
							print("Key '\(key)' not found:", context.debugDescription)
							print("codingPath:", context.codingPath)
							completion(.failure(Errors.apiError("Error occurred")))
						} catch let DecodingError.valueNotFound(value, context) {
							print("Value '\(value)' not found:", context.debugDescription)
							print("codingPath:", context.codingPath)
							completion(.failure(Errors.apiError("Error occurred")))
						} catch let DecodingError.typeMismatch(type, context)  {
							print("Type '\(type)' mismatch:", context.debugDescription)
							print("codingPath:", context.codingPath)
							completion(.failure(Errors.apiError("Error occurred")))
						} catch {
							print("error: ", error)
							completion(.failure(Errors.apiError("Error occurred")))
						}
						
						
						
					} else {
						completion(.failure(Errors.emptyResponse("An error occurred \n please check your request and try again")))
					}
				}
		}
		
		
	
}

public enum Errors : Error {
	case emptyResponse(String)
	case custom(Int, String)
	case apiError(String)
	
	func get() -> String {
		switch self {
		case .apiError(let error):
			return error
		case .emptyResponse(let error):
			return error
		case .custom(_, let error):
			return error
		}
	}
}



class Connectivity {
	class func isConnectedToInternet() ->Bool {
		return NetworkReachabilityManager()!.isReachable
	}
}
