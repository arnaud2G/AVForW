//
//  ListHotelViewController.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 12/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import UIKit
import RxSwift

class ListHotelViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        SearchManager.main.startSearch()
        observeResultPage()
    }
    
    private func observeResultPage() {
        SearchManager.main.page.asObservable()
            .distinctUntilChanged()
            .filter{$0 > 0}
            .subscribe(onNext:{
                [weak self] page in
                DispatchQueue.main.sync {
                    self?.tableView.insertSections(IndexSet(self!.tableView.numberOfSections-1...SearchManager.main.resultats.count-1), with:.fade)
                }
            }).addDisposableTo(disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Le +1 Correspond à la cellule de chargement
        return SearchManager.main.resultats.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == tableView.numberOfSections - 1 {return 1} // Cas du chargement
        return SearchManager.main.resultats[section].weekends.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {return 0} // Cas du chargement
        return 120
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {return nil} // Cas du chargement
        if let hotelView = Bundle.main.loadNibNamed("HotelView", owner: self, options: nil)!.first as? HotelView {
            hotelView.setHotel(hotel: SearchManager.main.resultats[section])
            return hotelView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == tableView.numberOfSections - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellId")!
            (cell.viewWithTag(1) as! UIActivityIndicatorView).startAnimating()
            return cell
        }
        
        SearchManager.main.userPage.value = indexPath.section/SearchManager.main.limit
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekendCellId")! as! WeekendCell
        cell.weekend = SearchManager.main.resultats[indexPath.section].weekends[indexPath.row]
        return cell
    }
}

// MARK: - Cellule weekend
class WeekendCell:UITableViewCell {
    
    @IBOutlet weak var lblThem: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    var weekend:Weekend! {
        didSet{
            lblThem.text = weekend.printTopTheme()
            lblTitle.text = weekend.label
            downloadImage(imageUrl: weekend.imageUrl)
        }
    }
    
    private func downloadImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else {return} // Ici on peut mettre une image commune
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data, error == nil else { return } // Ici on peut mettre une image commune
            DispatchQueue.main.async(execute: {
                () -> Void in
                if self.weekend.imageUrl == imageUrl {
                    self.imgBack.image = UIImage(data: data) // On vérifie que le téléchargement correspond toujours à la cellule
                }
            })
        }.resume()
    }
}
