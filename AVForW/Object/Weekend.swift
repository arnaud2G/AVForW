//
//  Weekend.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 12/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import UIKit
import RxSwift

struct Weekend {
    
    let label:String
    let imageUrl:String
    let topTheme:[String]
    
    var image:Variable<UIImage?> = Variable(nil)
    
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
    
    func dlImage() {
        // SI besoin on peut télécharger l'image qui est ensuite stocker dans la variable image
        let url = URL(string: imageUrl)!
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data, error == nil else { return }
            self.image.value = UIImage(data: data)
            }.resume()
    }
}
