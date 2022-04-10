//
//  Today.swift
//  Weather App
//
//  Created by Tornike on 17.02.22.
//

import Foundation


struct CurrentWeatherResponce: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let timezone: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

struct Clouds: Codable {
    let all: Int64
}


