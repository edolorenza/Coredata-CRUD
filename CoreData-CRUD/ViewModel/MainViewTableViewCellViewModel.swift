//
//  MainViewTableViewCellViewModel.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

struct MainViewTableViewCellViewModel {
    let avengers: Avengers
    
    init(avengers: Avengers) {
        self.avengers = avengers
    }
    
    var image: UIImage? {
        if let imageData = avengers.image {
            return UIImage(data: imageData as Data)
        }
        return UIImage(named: "photo")
    }
    
    
    var name: String {
        guard let firstName = avengers.firstName else { return "" }
        guard let lastName = avengers.lastName else { return " "}
        return firstName + lastName
    }
    
    var date: String? {
        return avengers.birthDate
    }
}
