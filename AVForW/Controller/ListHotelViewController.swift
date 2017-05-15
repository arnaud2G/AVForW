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
        
        self.title = "Mes supers weekends !"
        
        // Init table
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Init recherche
        SearchManager.main.startSearch()
        
        // Observe la recherche
        observeResultPage()
    }
    
    private func observeResultPage() {
        // On observe les pages pour insérer les résultats dans la table si besoin
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
    
    //MARK: Définition de la table
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weekendViewController = storyboard?.instantiateViewController(withIdentifier: "WeekendViewController") as! WeekendViewController
        // En entré on utilise l'indexPath pour retrouver le couple hotel/weekend ainsi que l'image pour éviter de la re-télécharger
        weekendViewController.indexPath = indexPath
        self.navigationController?.pushViewController(weekendViewController, animated: true)
    }
}
