//
//  ViewController.swift
//  Weather
//
//  Created by Louie McConnell on 10/9/17.
//  Copyright © 2017 Louie McConnell. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class LandingViewController: UIViewController {
    
    var logoImageView: UIImageView!
    var temperatureLabel: UILabel!
    var rainOrSunnyImageView: UIImageView!
    var rainOrSunnyTime: UILabel!
    var descriptionTextView: UITextView!
    var temp: Int!
    var rainingInAnHour: Bool!
    var rainingTime: Date!
    var weatherDescription: String!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var attributionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        NotificationCenter.default.addObserver(self, selector: #selector(getLocation), name: Notification.Name(rawValue: "getWeather"), object: nil)
        addWeatherLogo()
        addAttributionButton()
    }
    
    func getLocation() {
        // Ask for Authorization from the User.
        if CLLocationManager.authorizationStatus().rawValue == 0 {
            locationManager.requestAlwaysAuthorization()
        }
        //Sets the locations
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }
    
    func updateWeatherFields(lat: Double, long: Double) {
        Utils.getWeatherData(lat: lat, long: long, callback: {(temp, desc, willRain, rainTime) in
            // if this is the first time everything is loaded
            if self.temperatureLabel == nil {
                self.addTemperatureLabel(temp: temp)
                self.addRainOrSunnyIndicator(rain: willRain, rainTime: rainTime)
                self.addDescriptionTextView(text: desc)
            } else {
                self.temperatureLabel.text = String(temp) + "°"
                self.rainOrSunnyImageView.image = willRain ? #imageLiteral(resourceName: "rainy_cloud") : #imageLiteral(resourceName: "suntest")
                self.rainOrSunnyTime.text = willRain ? "Rain at " + Utils.getTimeFromUnixEpoch(epochTime: rainTime) : "Clear skies!"
                self.descriptionTextView.text = desc
            }
        })
    }
    
    //Sets up UI for weather logo
    func addWeatherLogo() {
        logoImageView = UIImageView()
        logoImageView.frame = CGRect(x: 12, y: 0.05 * view.frame.height, width: view.frame.width, height: 0.2 * view.frame.height)
        logoImageView.image = #imageLiteral(resourceName: "Asset 1")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
    }
    
    //Adds temperature label
    func addTemperatureLabel(temp: Int) {
        let offset = CGFloat(60)
        temperatureLabel = UILabel()
        temperatureLabel.frame = CGRect(x: offset, y: 210, width: self.view.frame.width-offset, height: 150)
        temperatureLabel.backgroundColor = UIColor.clear
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.text = String(temp) + "°"
        temperatureLabel.font = UIFont(name: "Helvetica Neue", size: 180)
        temperatureLabel.textAlignment = .center
        view.addSubview(temperatureLabel)
    }
    
    //Adds indicator for sunshine or rain
    func addRainOrSunnyIndicator(rain: Bool, rainTime: Int) {
        rainOrSunnyImageView = UIImageView(frame: CGRect(x: 20, y: temperatureLabel.frame.maxY + 70, width: 60, height: 60))
        rainOrSunnyImageView.image = rain ? #imageLiteral(resourceName: "rainy_cloud") : #imageLiteral(resourceName: "suntest")
        rainOrSunnyImageView.clipsToBounds = true
        rainOrSunnyImageView.contentMode = .scaleAspectFit
        
        rainOrSunnyTime = UILabel()
        rainOrSunnyTime.frame = CGRect(x: rainOrSunnyImageView.frame.maxX + 10, y: rainOrSunnyImageView.frame.minY, width: view.frame.width - 90, height: 60)
        rainOrSunnyTime.backgroundColor = UIColor.clear
        rainOrSunnyTime.textColor = UIColor.white
        rainOrSunnyTime.text = rain ? "Rain at " + Utils.getTimeFromUnixEpoch(epochTime: rainTime) : "Clear skies!"
        rainOrSunnyTime.font = UIFont(name: "Helvetica Neue", size: 50)
        
        view.addSubview(rainOrSunnyImageView)
        view.addSubview(rainOrSunnyTime)
    }
    
    //Adds description text
    func addDescriptionTextView(text: String) {
        descriptionTextView = UITextView()
        descriptionTextView.frame = CGRect(x: Double(0.1*view.frame.width), y: Double(rainOrSunnyTime.frame.maxY + 25), width: Double(0.8*view.frame.width), height: Double(180))
        descriptionTextView.textAlignment = .center
        descriptionTextView.font = UIFont(name: "Helvetica Neue", size: 23)
        descriptionTextView.text = text
        descriptionTextView.textColor = UIColor.white
        descriptionTextView.backgroundColor = UIColor.clear
        descriptionTextView.isEditable = false
        view.addSubview(descriptionTextView)
    }
    
    //Adds PoweredbyDarkSky link
    func addAttributionButton() {
        let width = self.view.frame.width / 2
        let height = 30
        attributionButton = UIButton(frame: CGRect(x: Double(view.frame.width - width - 2), y: Double(view.frame.height - CGFloat(height) - 2), width: Double(width), height: Double(height)))
        attributionButton.setTitle("Powered by Dark Sky", for: .normal)
        attributionButton.setTitleColor(UIColor.lightGray, for: .normal)
        attributionButton.backgroundColor = UIColor.clear
        attributionButton.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Light", size: 19)
        attributionButton.addTarget(self, action: #selector(goToWebsiteInSafari), for: .touchUpInside)
        view.addSubview(attributionButton)
    }
    
    //Goes to DarkSky if link is clicked
    func goToWebsiteInSafari() {
        if let url = URL(string: "https://darksky.net/poweredby/"){
            UIApplication.shared.openURL(url)
        }
    }
}

extension LandingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[locations.count-1] as CLLocation
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        self.updateWeatherFields(lat: lat, long: long)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

