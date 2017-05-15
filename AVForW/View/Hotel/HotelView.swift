//
//  HotelHeaderCell.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 12/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class HotelView:UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    
    func setHotel(hotel:Hotel) {
        lblTitle.text = hotel.label
        lblAdress.text = hotel.address
        lblAverage.text = "Note : \(hotel.review)/10" 
    }
}


