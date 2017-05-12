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
                    self?.tableView.insertSections(IndexSet(integer: (page-1)), with: .fade)
                }
            }).addDisposableTo(disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Le +1 Correspond à la cellule de chargement
        print(SearchManager.main.resultats.count)
        return SearchManager.main.resultats.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchManager.main.resultats[section]?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == tableView.numberOfSections - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellId")!
            return cell
        }
        
        SearchManager.main.userPage.value = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCellId")!
        cell.textLabel?.text = SearchManager.main.resultats[indexPath.section]![indexPath.row].label
        return cell
    }
}
