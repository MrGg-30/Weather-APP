//
//  ViewController.swift
//  Weather App
//
//  Created by Tornike on 31.01.22.
//

import UIKit
import SDWebImage
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var manager: CLLocationManager = CLLocationManager()
    var weatherService = WeatherService()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var blurredEffectView: UIVisualEffectView!
    var dict : [Int:[List]] = [:]
    @IBOutlet var errorPage : ErrorView!
    var x = 1
    
    var weatherForecast = [ForecastResponce]()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
       
        getCoordinates(latitude: first.coordinate.latitude, longitude :  first.coordinate.longitude)
    }
    
    func getCoordinates(latitude : Double, longitude : Double){
        blurredEffectView.isHidden = false
        loader.startAnimating()
        weatherService.loadForecast(lat : latitude, lon : longitude){ [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case.success(let forecast):
                    self!.weatherForecast.append(forecast)
                    if self!.weatherForecast.count != 0{
                        self!.fillDictionary()
                        self?.tableView.reloadData()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.weatherForecast.count != 0 {
            return dict[section]!.count
        }
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for : indexPath)
        if let tableViewCell = cell as? TableViewCell {
            if weatherForecast.count != 0 {
                let time = String((dict[indexPath.section]?[indexPath.row].dt_txt)!).suffix(8).prefix(5)
                
                tableViewCell.timeLabeL.text = String(time)
                
                tableViewCell.weather.text = dict[indexPath.section]![indexPath.row].weather[0].description
                
                tableViewCell.temp.text = String(Int(floor(dict[indexPath.section]![indexPath.row].main.temp - 273.15))) + "°C"
                let imageUrl = "https://openweathermap.org/img/w/" +
                    dict[indexPath.section]![indexPath.row].weather[0].icon + ".png"
                tableViewCell.imageView?.sd_setImage(with: URL(string: imageUrl))
               
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ForecastTableViewSectionHeaderView(reuseIdentifier: String(describing: ForecastTableViewSectionHeaderView.self))
       
        if dict[0] != nil {
            let currDate = String((dict[section]?[0].dt_txt)!).prefix(10)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let date = dateFormat.date(from: String(currDate))
            dateFormat.dateFormat = "EEEE"
            header.titleLabel.text = dateFormat.string(from: date!)
        }
        
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func viewDidLayoutSubviews() {
        navigationItem.title = "Forecast"
                
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))

        navigationItem.leftBarButtonItem = refreshButton
    }
    
    @objc func refreshData(){
        dict.removeAll()
        loader.startAnimating()
        blurredEffectView.isHidden = false
        guard let latitude = manager.location?.coordinate.latitude, let longitude =
                manager.location?.coordinate.longitude else {
            return
        }
        getCoordinates(latitude: latitude, longitude: longitude)
    }
    
    
    
    func fillDictionary(){
        let str = self.weatherForecast[0].list[0].dt_txt
        
        var substr = str.prefix(10)
        var n = 0
        for i in 0...self.weatherForecast[0].list.count - 1 {
            let time = self.weatherForecast[0].list[i].dt_txt
            let timeSubstr = time.prefix(10)
            if substr == timeSubstr {
                if dict[n]?.count != nil {
                    if !(dict[n]?.contains(weatherForecast[0].list[i]))! {
                        dict[n]?.append(weatherForecast[0].list[i])
                    }
                } else {
                    var array = [List]()
                    array.append(weatherForecast[0].list[i])
                    dict[n] = array
                }
            } else {
                substr = timeSubstr
                n = n + 1;
               
                var array = [List]()
                array.append(weatherForecast[0].list[i])
                dict[n] = array
            }
        }
       
    }
}

class ForecastTableViewSectionHeaderView: UITableViewHeaderFooterView {

    var titleLabel = UILabel(frame: .zero)
    var backView = UIView(frame: .zero)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .white
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1).cgColor

        addSubview(backView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = .darkGray

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 32.0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

}

