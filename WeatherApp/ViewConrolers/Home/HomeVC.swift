//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 16/01/2023.
//

import UIKit
import RxSwift
import CoreLocation

class HomeVC: UIViewController, CLLocationManagerDelegate {
	
	//MARK: - properties
	private var disposeBag = DisposeBag()
	private var viewModel = HomeViewModel()
	private var currentLocation: CLLocation!
	private var locationManager = CLLocationManager()
	private var climate: [List1] = []
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .white
		addObservers()
		configureUI()
		registerCells()
		checkIfLocationIsEnabled()
    }
	
	
	private func registerCells() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(HistoryDegreeCell.self, forCellReuseIdentifier: K.cells.history_cell)
	}
	
	
	private lazy var imgBackground: UIImageView = {
		let img = UIImageView()
		img.translatesAutoresizingMaskIntoConstraints = false
		img.heightAnchor.constraint(equalToConstant: 250).isActive = true
		img.contentMode = .scaleAspectFill
		return img
	}()
	
	private lazy var lblDegrees: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		
		lbl.font = UIFont.systemFont(ofSize: 35)
		return lbl
	}()
	
	private var lblCurrentReadingTitle: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		lbl.font = UIFont.systemFont(ofSize: 25)
		return lbl
	}()
	
	private var currentReadingView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		view.heightAnchor.constraint(equalToConstant: 150).isActive = true
		return view
	}()
	
	private lazy var currentReadingStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.backgroundColor = .clear
		stackView.distribution = .fillEqually
		stackView.clipsToBounds = true
		stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
		stackView.axis = .horizontal
		return stackView
	}()
	
	private lazy var minView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var lblMin: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		lbl.text = K.home.lblMin
		return lbl
	}()
	
	private var lblMinDegree: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		return lbl
	}()
	
	private lazy var currentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var lblCurrentDegree: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		return lbl
	}()
	
	private var lblCurrent: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		lbl.text = K.home.lblCurrent
		return lbl
	}()
	
	private lazy var maxView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var lblMaxDegrees: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		return lbl
	}()
	
	private var lblMax: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = .white
		lbl.text = K.home.lblMax
		return lbl
	}()
	
	private lazy var tableView: UITableView = {
		var tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .clear
		return tableView
	}()
	
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	private func addObservers() {
		
		viewModel.currentWeatherResponse.subscribe(onNext: {[weak self] res in
			self?.fetchHistoryWeather()
			self?.lblDegrees.text = "\(res.main.temp)".toDegrees()
			self?.lblCurrentReadingTitle.text = res.weather[0].main
			self?.lblMinDegree.text = "\(res.main.tempMin)".toDegrees()
			self?.lblCurrentDegree.text = "\(res.main.temp)".toDegrees()
			self?.lblMaxDegrees.text = "\(res.main.tempMax)".toDegrees()
						
			if res.weather[0].main == WeatherConditions.cloudy.rawValue {
				self?.imgBackground.image = UIImage(named: K.images.sea_cloudy)
				self?.view.backgroundColor = getColor(weatherType: .cloudy)
			}else if res.weather[0].main == WeatherConditions.rainy.rawValue {
				self?.imgBackground.image = UIImage(named: K.images.sea_rainy)
				self?.view.backgroundColor = getColor(weatherType: .rainy)
			}else if res.weather[0].main == WeatherConditions.sunny.rawValue {
				self?.imgBackground.image = UIImage(named: K.images.sea_sunny)
				self?.view.backgroundColor = getColor(weatherType: .sunny)
			}else {
				self?.imgBackground.image = UIImage(named:  K.images.sea_sunny)
				self?.view.backgroundColor = getColor(weatherType: .sunny)
			}
			
		}).disposed(by: disposeBag)
		
		viewModel.weatherListResponse.subscribe(onNext: {[weak self] res in
			self?.climate.removeAll()
			self?.climate.append(contentsOf: res)
			self?.tableView.reloadData()
			self?.hideProgressDialog()
		}).disposed(by: disposeBag)
		
		
		viewModel.errorResponse.subscribe(onNext: {[weak self] res in
			self?.hideProgressDialog()
			showAlert(title: "", message: res.get(), vc: HomeVC()) { action in
				self?.dismiss(animated: false)
			}
		}).disposed(by: disposeBag)
	}
	
	private func fetchHistoryWeather() {
		viewModel.fetchWeatherHistory(lon: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude)
	}
	
	
	private func fetchCurrentWeather() {
		locationManager.stopUpdatingLocation()
		if isConnectedToInternet() {
			self.viewModel.fetchCurrentWeather(lon: self.currentLocation.coordinate.longitude, lat: self.currentLocation.coordinate.latitude)
		}else {
			self.hideProgressDialog()
			showAlert(title: "", message: K.strings.networkMessage, vc: self) { action in
				UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
			}
		}
	}
	
	func checkIfLocationIsEnabled() {
		
		locationManager.delegate = nil
		let status  = CLLocationManager.authorizationStatus()
		
		
		self.showProgressDialog(message: K.strings.loadingMessage)
		
		if status == .notDetermined {
			locationManager.delegate = self
			locationManager.requestWhenInUseAuthorization()
		} else if status == .denied || status == .restricted {
			self.hideProgressDialog()
			showPermissionDialog()
		} else if  status == .authorizedAlways || status == .authorizedWhenInUse {
			locationManager.delegate = self
			locationManager.startUpdatingLocation()
			
			guard let currentLocation = self.locationManager.location else {
				return
			}
			self.currentLocation = currentLocation
			self.fetchCurrentWeather()
			
		}
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkIfLocationIsEnabled()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		checkIfLocationIsEnabled()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		checkIfLocationIsEnabled()
	}
    

}

extension HomeVC {
	
	
	private func configureUI() {
		
		self.view.addSubview(imgBackground)
		self.view.addSubview(currentReadingView)
		currentReadingView.addSubview(lblDegrees)
		currentReadingView.addSubview(lblCurrentReadingTitle)
		self.view.addSubview(currentReadingStackView)
		currentReadingStackView.addArrangedSubview(minView)
		currentReadingStackView.addArrangedSubview(currentView)
		currentReadingStackView.addArrangedSubview(maxView)
		
		
		minView.addSubview(lblMinDegree)
		minView.addSubview(lblMin)
		
		currentView.addSubview(lblCurrentDegree)
		currentView.addSubview(lblCurrent)
		
		maxView.addSubview(lblMaxDegrees)
		maxView.addSubview(lblMax)
		
		self.view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			imgBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
			imgBackground.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			imgBackground.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
			
			currentReadingView.leadingAnchor.constraint(equalTo: imgBackground.leadingAnchor, constant: 10),
			currentReadingView.trailingAnchor.constraint(equalTo: imgBackground.trailingAnchor, constant: -10),
			currentReadingView.centerYAnchor.constraint(equalTo: imgBackground.centerYAnchor),
			currentReadingView.centerXAnchor.constraint(equalTo: imgBackground.centerXAnchor),
			
			lblDegrees.centerXAnchor.constraint(equalTo: currentReadingView.centerXAnchor),
			lblDegrees.centerYAnchor.constraint(equalTo: currentReadingView.centerYAnchor),
			
			lblCurrentReadingTitle.centerYAnchor.constraint(equalTo: currentReadingView.centerYAnchor, constant: 40),
			lblCurrentReadingTitle.centerXAnchor.constraint(equalTo: currentReadingView.centerXAnchor),
			
			currentReadingStackView.topAnchor.constraint(equalTo: imgBackground.bottomAnchor, constant: 60),
			currentReadingStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
			currentReadingStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
			
			//MARK: - Current readding minReadings
			
			lblMinDegree.centerXAnchor.constraint(equalTo: minView.centerXAnchor),
			lblMinDegree.centerYAnchor.constraint(equalTo: minView.centerYAnchor),
			lblMin.centerYAnchor.constraint(equalTo: minView.centerYAnchor, constant: 20),
			lblMin.centerXAnchor.constraint(equalTo: minView.centerXAnchor),
			
			lblCurrentDegree.centerXAnchor.constraint(equalTo: currentView.centerXAnchor),
			lblCurrentDegree.centerYAnchor.constraint(equalTo: currentView.centerYAnchor),
			lblCurrent.centerYAnchor.constraint(equalTo: currentView.centerYAnchor, constant: 20),
			lblCurrent.centerXAnchor.constraint(equalTo: currentView.centerXAnchor),
			
			lblMaxDegrees.centerXAnchor.constraint(equalTo: maxView.centerXAnchor),
			lblMaxDegrees.centerYAnchor.constraint(equalTo: maxView.centerYAnchor),
			lblMax.centerYAnchor.constraint(equalTo: maxView.centerYAnchor, constant: 20),
			lblMax.centerXAnchor.constraint(equalTo: maxView.centerXAnchor),
			
			//MARK: - tableView constraints
			tableView.topAnchor.constraint(equalTo: currentReadingStackView.bottomAnchor, constant: 20),
			tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
			
		])
		
	}
	
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return climate.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.history_cell, for: indexPath) as! HistoryDegreeCell
		cell.backgroundColor = .clear
		cell.selectionStyle = .none
		cell.setupData(data: climate[indexPath.row])
		return cell
	}
	
	
	func showPermissionDialog() {
		showAlert(title: "", message: K.strings.locationPermission, vc: self) { action in
			UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
		}
	}
	
	
}
