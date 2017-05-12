//
//  Hotel.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 12/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import CoreLocation

struct Hotel {
    
    let label:String
    let review:Double
    let location:CLLocationCoordinate2D
    
    let weekends:[Weekend]
    
    init?(json: [String: Any]) {
        guard
            let label = json["label"] as? String,
            let review = json["review"] as? [String:Any], let average = review["average"] as? Double,
            let location = json["location"] as? [String:Any], let latitude = location["latitude"] as? Double, let longitude = location["longitude"] as? Double,
            let weekends = json["weekend"] as? [[String:Any]]
            else { return nil }
        self.label = label
        self.review = average
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.weekends = weekends.map{Weekend(json: $0)}.filter{$0 != nil} as! [Weekend]
    }
}
