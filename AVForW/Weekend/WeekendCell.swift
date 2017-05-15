//
//  WeekendCell.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 15/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

// MARK: - Cellule weekend
class WeekendCell:UITableViewCell {
    
    @IBOutlet weak var lblThem: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    var disposeBag:DisposeBag?
    
    var weekend:Weekend! {
        didSet{
            lblThem.text = weekend.printTopTheme()
            lblTitle.text = weekend.label
            
            disposeBag = DisposeBag()
            
            // On observe l'image, si elle n'existe pas on lance le téléchargement
            weekend.image.asObservable().subscribe(onNext:{
                [weak self] image in
                if let image = image {
                    DispatchQueue.main.async(execute: {
                        () -> Void in
                        self?.imgBack.image = image
                    })
                } else {
                    self?.weekend.dlImage()
                }
            }).addDisposableTo(disposeBag!)
        }
    }
}
