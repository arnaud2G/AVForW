//
//  SearchManager.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 12/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import RxSwift

class SearchManager {
    static let main = SearchManager()
    
    // Les paramètres limit et page me permettent de controller le nombre de résultats
    let apiUrl = "http://api.weekendesk.com/api/weekends.json?orderBy=priceQuality&locale=fr_FR&limit=%d&page=%d"
    let limit:Int = 10
    // L'observation de la variable page va permettre de mettre à jours la liste des hotels
    var page:Variable<Int> = Variable(0)
    
    // L'observation de la variable userPage va permettre de savoir lorsqu'il faut rechercher de nouveaux hotels
    var userPage:Variable<Int?> = Variable(nil)
    
    // Les résultats sont donnés sous forme de dictionnaire [page:[Hotel]]
    var resultats = [Int:[Hotel]]()
    
    let disposeBag = DisposeBag()
    
    init() {
        userPage.asObservable()
            .filter{$0 != nil}
            .distinctUntilChanged{$0! == $1!}
            .subscribe(onNext:{
                [weak self] userPage in
                if userPage! == (self!.page.value - 1) {
                    self?.search()
                }
            }).addDisposableTo(disposeBag)
    }
    
    func startSearch() {
        self.page.value = 0
        search()
    }
    
    func search() {
        print("On cherche sur la page \(self.page.value)")
        let url = URL(string: String(format: apiUrl, arguments: [limit,page.value]))
        let urlRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            data, urlRet, error in
            
            if let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                if let hotels = json["exactMatch"] as? [[String: Any]] {
                    let newHotels = hotels.map{return Hotel(json: $0)}.filter{$0 != nil} as! [Hotel]
                    self.resultats[self.page.value] = newHotels
                }
                self.page.value += 1
            }
            
        }).resume()
    }
}
