//
//  HistoryDegreeCell.swift
//  WeatherApp
//
//  Created by Andrew Ananda on 17/01/2023.
//

import UIKit

class HistoryDegreeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
			super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.contentView.addSubview(lblTitle)
		self.contentView.addSubview(imgWeather)
		self.contentView.addSubview(lblDegrees)
		
		
		NSLayoutConstraint.activate([
		   lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
		   lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
		   lblTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
		   imgWeather.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
		   imgWeather.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
		   imgWeather.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
		   lblDegrees.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
		   lblDegrees.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
		   lblDegrees.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
		])
	 }

	 required init?(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
		 
	}
	
	func setupData(data: List1) {
		lblTitle.text = getFormatedDate(dateString: data.dtTxt)
		lblDegrees.text = NSString(format:"\(data.main.temp)%@" as NSString, "\u{00B0}") as String
		if data.weather[0].main == "Clouds" {
			imgWeather.image = UIImage(named: K.images.partly_sunny)
		}else if data.weather[0].main == "Rain" {
			imgWeather.image = UIImage(named: K.images.rain)
		}else {
			imgWeather.image = UIImage(named: K.images.clear)
		}
	}
	
	
	lazy var containerView:UIView = {
	  let view = UIView()
	  view.translatesAutoresizingMaskIntoConstraints = false
	  view.clipsToBounds = true
	  return view
	}()
	
	
	lazy var lblTitle: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.font = UIFont.systemFont(ofSize: 15)
		lbl.textColor = .white
		return lbl
	}()
	
	lazy var imgWeather: UIImageView = {
		let img = UIImageView()
		img.translatesAutoresizingMaskIntoConstraints = false
		img.heightAnchor.constraint(equalToConstant: 25).isActive = true
		img.widthAnchor.constraint(equalToConstant: 25).isActive = true
		img.tintColor = .white
		return img
	}()
	
	lazy var lblDegrees: UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.font = UIFont.systemFont(ofSize: 15)
		lbl.textColor = .white
		return lbl
	}()

}
