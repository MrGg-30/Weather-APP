//
//  TodayService.swift
//  Weather App
//
//  Created by Tornike on 17.02.22.
//


import Foundation
import CoreLocation


class TodayService {
     
    private let key = "6a7c95efee7bcc615c2d5e9a57b061f1"
    private var components = URLComponents()
    
    init() {
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
    }
    
    func loadImage(){
      
    }
    
    func loadForecast(lat : Double, lon : Double, completion: @escaping (Result<CurrentWeatherResponce, ServiceError>) -> ()){
        let parameters = [
            "lat": lat.description,
            "lon": lon.description,
            "appid": key.description
        ]
        
        components.queryItems = parameters.map{key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                if error != nil {
                    completion(.failure(ServiceError.httpLayerError))
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(CurrentWeatherResponce.self, from: data)
                        completion(.success(result.self))
                       
                    } catch {
                        completion(.failure(ServiceError.parseError))
                    }
                } else {
                    completion(.failure(ServiceError.noDataError))
                }
            })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParametersError))
        }
    }
}

