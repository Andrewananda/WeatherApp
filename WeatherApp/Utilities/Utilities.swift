//
//  Utilities.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 17/01/2023.
//

import Foundation
import UIKit
import Alamofire

func getColor(weatherType: WeatherType) -> UIColor {
	
	switch weatherType {
	case .sunny:
		return UIColor(named: "SunnyColor") ?? UIColor.white
	case .rainy:
		return UIColor(named: "RainyColor") ?? UIColor.white
	case .cloudy:
		return UIColor(named: "CloudyColor") ?? UIColor.white
	}
	
}


enum WeatherType {
	case sunny
	case cloudy
	case rainy
}


func getFormatedDate(dateString: String) -> String {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	let date = dateFormatter.date(from:dateString)!
	
	
	dateFormatter.dateFormat = "EEEE"
	let nameOfMonth = dateFormatter.string(from: date)
	return nameOfMonth
}



func removeDuplicateElements(data: [List1]) -> [List1] {
	var uniqueData = [List1]()
	
	for item in data {
		if !uniqueData.contains(where: {getFormatedDate(dateString: $0.dtTxt) == getFormatedDate(dateString: item.dtTxt) }) {
			uniqueData.append(item)
		}
	}
	return uniqueData
}

func getFormatedDate(date: String) -> String {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	let newDate = dateFormatter.date(from: date)!
	
	dateFormatter.dateFormat = "yyy-MM-dd"
	dateFormatter.string(from: newDate)
	
	return "\(newDate)"
	
}

enum WeatherConditions: String{
	case rainy = "Rain"
	case cloudy = "Clouds"
	case sunny = "Sun"
	
}



func showAlert(title: String, message: String, vc: UIViewController, res: @escaping (UIAlertAction) -> Void) {
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
	
	let okAction = UIAlertAction(title: "Dismis", style: .default, handler: res)
	alert.addAction(okAction)
	vc.present(alert, animated: false)
}





extension UIViewController {
	func showProgressDialog(message: String) {
		let viewController = ProgressVC()
		viewController.message = message
		viewController.modalPresentationStyle = .fullScreen
		self.present(viewController, animated: false, completion: nil)
	}
	
	func hideProgressDialog() {
		self.dismiss(animated: false)
	}
}

extension String {
	
	func toDegrees() -> String {
		return NSString(format: "\(self)%@" as NSString, "\u{00B0}") as String
	}
}


func isConnectedToInternet() -> Bool {
	return NetworkReachabilityManager()?.isReachable ?? false
}
