//
//  ProgressVC.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 17/01/2023.
//

import UIKit

class ProgressVC: UIViewController {
	
	var message = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
		activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
		activityIndicator.color = UIColor.black
		activityIndicator.startAnimating()
		return activityIndicator
	}()
	
	lazy var lblMessage: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.font = UIFont.systemFont(ofSize: 18)
		lbl.textColor = UIColor.black
		lbl.text = message
		return lbl
	}()
	
	
	
	private func configureUI() {
		self.view.backgroundColor = .white
		self.view.addSubview(activityIndicator)
		self.view.addSubview(lblMessage)
		
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			
			lblMessage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20),
			lblMessage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
		])
	}
	

}
