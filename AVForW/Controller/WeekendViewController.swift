//
//  WeekendViewController.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 15/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

class WeekendViewController: UIViewController {
    
    var indexPath:IndexPath!
    
    @IBOutlet weak var vHotel: UIView!
    
    @IBOutlet weak var lblTopTheme: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // On attribu l'hotel à la vue du haut
        if let hotelView = Bundle.main.loadNibNamed("HotelView", owner: self, options: nil)!.first as? HotelView {
            hotelView.setHotel(hotel: SearchManager.main.resultats[indexPath.section])
            vHotel.addOnAllView(subview: hotelView)
        }
        
        lblTitle.text = SearchManager.main.resultats[indexPath.section].weekends[indexPath.row].label
        lblTopTheme.text = SearchManager.main.resultats[indexPath.section].weekends[indexPath.row].printTopTheme()
        
        if let image = SearchManager.main.resultats[indexPath.section].weekends[indexPath.row].image.value {
            imgBack.image = image
        }
    }
}
