//
//  Utils.swift
//  Weather
//
//  Created by Louie McConnell on 10/9/17.
//  Copyright © 2017 Louie McConnell. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let endpoint = "https://api.darksky.net/forecast/"
let apiKey = "295a15b47e1a3e4649c5f43bfa41a17e"

class Utils {
    static func getWeatherData(lat: Double, long: Double, callback: @escaping (_ temp: Int, _ desc: String, _ raining: Bool, _ rainingTime: Int) -> ()){
        var req: URLRequest!
        
        do {
            try req = URLRequest(url: "\(endpoint)\(apiKey)/\(String(lat)),\(String(long))", method: HTTPMethod.get)
        } catch {
            print(error.localizedDescription)
        }
        
        Alamofire.request(req).responseJSON { (response) in
            if let data = response.result.value {
                var json = JSON(data)
                
                let temp: Int = Int(Double(json["currently"]["temperature"].stringValue)!)
                let weatherDescription: String = json["daily"]["summary"].stringValue

                var raining: Bool = false
                var rainingTime: Int = 0
            
                for i in 0..<60 {
                    if json["minutely"]["data"][i]["precipProbability"] > 50 {
                        //print("rain")
                        rainingTime = Int(json["minutely"]["data"][i]["time"].stringValue)!
                        raining = true
                        break
                    } else if json["minutely"]["data"][i]["precipProbability"] < 50 {
                        //print("no rain")
                    }
                }
                
                callback(temp, weatherDescription, raining, rainingTime)
            }
        }
    }
    
    static func getTimeFromUnixEpoch(epochTime: Int) -> String {
        let newDate = Date(timeIntervalSince1970: TimeInterval(epochTime))
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone.current
        let dateString = formatter.string(from: newDate)
        return dateString
    }
}
