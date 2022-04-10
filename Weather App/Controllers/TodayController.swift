//
//  Today.swift
//  Weather App
//
//  Created by Tornike on 17.02.22.
//

import UIKit
import SDWebImage
import CoreLocation


class TodayController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager = CLLocationManager()
    var todayService = TodayService()
    var currWeatherResponse = [CurrentWeatherResponce]()
    
    @IBOutlet var tempLabel : UILabel!
    @IBOutlet var weatherImage : UIImageView!
    @IBOutlet var detailLabels : [UILabel]!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var blurredEffectView: UIVisualEffectView!
    @IBOutlet var errorPage : ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        navigationItem.title = "Today"
                
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData(sender:)))

        navigationItem.leftBarButtonItem = refreshButton

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareData))

        navigationItem.rightBarButtonItem = shareButton
        
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
       
        getCoordinates(latitude: first.coordinate.latitude, longitude :  first.coordinate.longitude)
    }
    
    func getCoordinates(latitude : Double, longitude : Double){
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.blurredEffectView.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }

        todayService.loadForecast(lat : latitude, lon : longitude){ [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case.success(let forecast):
                    self!.currWeatherResponse.append(forecast)
                    if self!.currWeatherResponse.count != 0{
                        self!.navigationItem.rightBarButtonItem?.isEnabled = true
                        self!.updatePage(lat : latitude, lon : longitude)
                        self?.loader.stopAnimating()
                        self?.blurredEffectView.isHidden = true
                    }
                case.failure(let error):
                    self!.handleError(errorText : error.description)
                }
            }
        }
    }
    
    func handleError(errorText : String){
       
       
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            guard let view = Bundle.main.loadNibNamed(String(describing: ErrorView.self), owner: self, options: nil)?.first as? ErrorView
            else  { return
            }
         
            self.errorPage = view
            self.errorPage.translatesAutoresizingMaskIntoConstraints = false
            guard let errorPage = self.errorPage else {
                return
            }
            
            self.view.addSubview(errorPage)
            
            NSLayoutConstraint.activate([
                errorPage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                errorPage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                errorPage.topAnchor.constraint(equalTo: self.view.topAnchor),
                errorPage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
         
            errorPage.errorL.text = String("The data couldn't be read because " + errorText).description + " occured"
            
        }
            
    }

    
    
    func updatePage(lat : Double, lon : Double){
        DispatchQueue.main.async { [self] in
            self.tempLabel.text = String(Int(self.currWeatherResponse[0].main.temp - 273.15)) + "°C" + " | " + String(self.currWeatherResponse[0].weather[0].main)
            self.detailLabels[0].text = String(self.currWeatherResponse[0].clouds.all) + " %"
            self.detailLabels[1].text = String(self.currWeatherResponse[0].main.humidity) + " mm"
            self.detailLabels[2].text = String(self.currWeatherResponse[0].main.pressure) + " hPa"
            self.detailLabels[3].text = String(self.currWeatherResponse[0].wind.speed) + "km/h"
            self.detailLabels[4].text = String(self.currWeatherResponse[0].wind.deg)
            
            let location = CLLocation(latitude: lat, longitude: lon)
            CLGeocoder().reverseGeocodeLocation(location) {
                (place, error) in
                if let error = error {
                    print(error)
                }
                guard let place = place?.first else { return }
                guard let city = place.locality else { return }
                guard let country = place.country else { return }
                self.detailLabels[5].text = city.description + "," + country.description
            }
            
            let imageUrl = "https://openweathermap.org/img/wn/" +
                String(self.currWeatherResponse[0].weather[0].icon) + ".png"
            self.weatherImage.sd_setImage(with: URL(string: imageUrl))
        }
    }
    
    @objc func shareData(){
        let image = UIImage()
        let sh = UIActivityViewController(activityItems: [image ], applicationActivities: nil)
        present(sh, animated: false)
    }

    @objc func refreshData(sender: UIButton){
        loader.startAnimating()
        blurredEffectView.isHidden = false
        guard let latitude = manager.location?.coordinate.latitude, let longitude =
                manager.location?.coordinate.longitude else {
            return
        }
        getCoordinates(latitude: latitude, longitude: longitude)
    }
    
    
}


