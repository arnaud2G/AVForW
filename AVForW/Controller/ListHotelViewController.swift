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
                    print(IndexSet((page - 1)*SearchManager.main.limit...(SearchManager.main.limit*page)-1))
                    self?.tableView.insertSections(IndexSet((page - 1)*SearchManager.main.limit...(SearchManager.main.limit*page)-1), with: .fade)
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
        if let hotelHeaderCell = Bundle.main.loadNibNamed("HotelHeaderCell", owner: self, options: nil)!.first as? HotelHeaderCell {
            hotelHeaderCell.setHotel(hotel: SearchManager.main.resultats[section])
            return hotelHeaderCell
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == tableView.numberOfSections - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellId")!
            return cell
        }
        
        SearchManager.main.userPage.value = indexPath.section/SearchManager.main.limit
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekendCellId")!
        cell.textLabel?.text = SearchManager.main.resultats[indexPath.section].weekends[indexPath.row].label
        return cell
    }
}

class ListWeekendCell:UITableViewCell {
    
}
