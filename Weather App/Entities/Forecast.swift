//
//  Forecast.swift
//  Weather App
//
//  Created by Tornike on 31.01.22.
//

import Foundation

struct ForecastResponce: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
}
struct List: Codable {
    let dt: Int64
    let main: MainF
    let weather: [WeatherF]
    let clouds: CloudsF
    let dt_txt: String
    let city: City?

}

struct MainF: Codable {
    let temp: Double
}

struct WeatherF: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct CloudsF: Codable {
    let all: Int64
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let timezone: Int
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

extension ForecastResponce : Equatable {
    static func ==(lhs: ForecastResponce, rhs: ForecastResponce) -> Bool {
        return lhs.list[0].dt_txt == lhs.list[0].dt_txt
    }
}


extension List : Equatable {
    static func ==(lhs: List, rhs: List) -> Bool {
        return lhs.dt_txt == rhs.dt_txt
    }
}
