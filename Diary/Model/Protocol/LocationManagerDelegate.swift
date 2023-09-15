//
//  LocationManagerDelegate.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/15.
//

protocol LocationManagerDelegate: AnyObject {
    func fetchWeatherData(latitude: String, longtitude: String)
}
