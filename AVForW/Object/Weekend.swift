//
//  Weekend.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 12/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

struct Weekend {
    
    let label:String
    let imageUrl:String
    let topTheme:[String]
    
    init?(json: [String: Any]) {
        guard
            let label = json["label"] as? String,
            let imageUrl = json["imageUrl"] as? String,
            let topTheme = json["topTheme"] as? [String]
            else { return nil }
        
        self.label = label
        self.imageUrl = imageUrl
        self.topTheme = topTheme
    }
    
    func printTopTheme() -> String? {
        return topTheme.joined(separator: "  ")
    }
}
